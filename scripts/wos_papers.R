# Extracting information from web of science "dental calculus" search on 2022-04-08
  # Search url: https://www.webofscience.com/wos/woscc/summary/64c9d655-fc5b-41bf-a09d-0c57e2ef57a9-2f9c1140/relevance/1

library(here)
library(patchwork)
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggwordcloud)
library(stringr)

# Data upload -------------------------------------------------------------

records_1 <- readr::read_tsv(here("data/wos-records/2022-04-08_wos-search-dentalcalc_pp0001-1000.txt"))
records_2 <- readr::read_tsv(here("data/wos-records/2022-04-08_wos-search-dentalcalc_pp1001-2000.txt"))
records_3 <- readr::read_tsv(here("data/wos-records/2022-04-08_wos-search-dentalcalc_pp2001-3000.txt"))
records_4 <- readr::read_tsv(here("data/wos-records/2022-04-08_wos-search-dentalcalc_pp3001-3300.txt"))

#782386 (purple)
#ab1866 (pink)
#d1295a (pinkish-red)
#e05b5c (peach)
#ffcc66 (starch)

diss_palette <- c(
  "#782386",
  "#ab1866",
  "#d1295a",
  "#e05b5c",
  "#ffcc66"
)

scales::show_col(diss_palette)

plot_theme <- theme_minimal() +
  theme(panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_blank(),
        plot.background = element_rect("white"))

# Data cleaning -----------------------------------------------------------

records <- list(records_1, records_2, records_3, records_4)

wos_records <- do.call(rbind, records)

# WHAT IS THE ID VARIABLE???
wos_records_cleaned <- wos_records %>%
  rename(
    type = PT,
    author = AU,
    title = TI,
    source = SO,
    keywords = DE, # need to check if this is actually keywords
    abstract = AB,
    year = PY,
    publisher = PU
  ) %>%
  mutate(
    source = as.factor(source)
  ) %>%
  filter(year != 2022)

wos_records_cleaned %>%
  filter(source == "ORAL DISEASES")

bioarch_records <- wos_records_cleaned %>%
  filter(str_detect(source, "(ANTHRO|ARCHAE|PALAEO|PALEO)")) %>%
  mutate(topic = "bioarch")

dental_records <- wos_records_cleaned %>%
  filter(str_detect(source, "(DENT|ORAL|CARIES|DONT)")) %>%
  mutate(topic = "clinical")

wos_records_comb <- bioarch_records %>%
  bind_rows(dental_records)

# articles with dental calculus in the title
calculus_title_articles <- wos_records_comb %>%
  filter(str_detect(title, "\\W*((?i)calculus(?-i))\\W*"))

article_keywords <- wos_records_comb %>%
  separate_rows(keywords, sep = ";") %>%
  filter(str_detect(keywords, "\\W*((?i)calculus(?-i))\\W*", negate = T)) %>%
  mutate(keywords = str_to_lower(keywords),
         keywords = str_trim(keywords)) %>%
  group_by(topic) %>%
  count(keywords, sort = T)

calculus_title_keywords <- calculus_title_articles %>%
  separate_rows(keywords, sep = ";")

bioarch_article_keywords <- bioarch_records %>%
  separate_rows(keywords, sep = ";") %>%
  filter(str_detect(keywords, "\\W*((?i)calculus(?-i))\\W*", negate = T)) %>%
  mutate(keywords = str_to_lower(keywords),
         keywords = str_trim(keywords)) %>%
  count(keywords, sort = T)

bioarch_title_keywords <- calculus_title_articles %>%
  filter(topic == "bioarch") %>%
  separate_rows(keywords, sep = ";") %>%
  filter(str_detect(keywords, "\\W*((?i)calculus(?-i))\\W*", negate = T)) %>%
  mutate(keywords = str_to_lower(keywords),
         keywords = str_trim(keywords)) %>%
  count(keywords, sort = T)

dental_article_keywords <- dental_records %>%
  separate_rows(keywords, sep = ";") %>%
  filter(str_detect(keywords, "\\W*((?i)calculus(?-i))\\W*", negate = T)) %>%
  mutate(keywords = str_to_lower(keywords),
         keywords = str_trim(keywords)) %>%
  count(keywords, sort = T)

dental_title_keywords <- dental_records %>%
  separate_rows(keywords, sep = ";") %>%
  filter(str_detect(title, "\\W*((?i)calculus(?-i))\\W*", negate = T)) %>%
  mutate(keywords = str_to_lower(keywords),
         keywords = str_trim(keywords)) %>%
  count(keywords, sort = T)

# number of journals and articles

n_articles <- wos_records_comb %>%
  group_by(topic) %>%
  count(title) %>%
  summarise(n = sum(n))

# standardise by using mean count per journal per year?
# dental_records %>%
#   filter(year != 2022) %>%
#   group_by(year) %>%
#   count(source) %>%
#   summarise(mean = mean(n, na.rm = T)) %>%
#   arrange(desc(year)) %>%
#   ggplot(aes(x = year, y = mean)) +
#     geom_line()

# bioarch_records %>%
#   filter(year != 2022) %>%
#   group_by(year) %>%
#   count(source) %>%
#   summarise(mean = mean(n, na.rm = T)) %>%
#   arrange(desc(year)) %>%
#   ggplot(aes(x = year, y = mean)) +
#   geom_line()
  
# Visualisations ----------------------------------------------------------

# line plot colours and legend
line_theme <- scale_colour_manual(values = c("#782386", "#ffcc66"),
                                  labels = paste0(levels(as.factor(wos_records_comb$topic)),
                                                         " (n = ", n_articles$n, ")"))

articles_plot <- wos_records_comb %>%
  group_by(year, topic) %>%
  count() %>%
  ggplot(aes(x = year, y = n, col = topic)) +
    geom_line(alpha = 0.8) +
    line_theme +
    theme_minimal() +
    theme(legend.position = "bottom")

# articles with dental calculus in the title

titles_plot <- wos_records_comb %>%
  filter(str_detect(title, "\\W*((?i)calculus(?-i))\\W*")) %>%
  group_by(year, topic) %>%
  count() %>%
  ggplot(aes(x = year, y = n, col = topic)) +
  geom_line(alpha = 0.8) +
  line_theme +
  theme_minimal() +
  theme(legend.position = "bottom", 
        legend.title = element_blank(),
        panel.grid.minor.x = element_blank())
  
# dental_keywords %>%
#   slice_head(n = 10) %>%
#   ggplot(aes(x = reorder(keywords, -n), y = n)) +
#     geom_col()

# bioarch_keywords %>%
#   slice_head(n = 10) %>%
#   ggplot(aes(x = reorder(keywords, -n), y = n)) +
#   geom_col()

# Word clouds

bioarch_article_wordcloud <- bioarch_article_keywords %>%
  slice_head(n = 20) %>%
  ggplot(aes(label = keywords, size = n, col = n)) +
    geom_text_wordcloud(shape = "circle") +
    theme_void() +
    scale_color_gradient(low = "#bd97c3", high = "#782386")

bioarch_title_wordcloud <- bioarch_title_keywords %>%
  slice_head(n = 20) %>%
  ggplot(aes(label = keywords, size = n, col = n)) +
  geom_text_wordcloud(shape = "circle") +
  theme_void() +
  scale_color_gradient(low = "#bd97c3", high = "#782386")


dental_article_wordcloud <- dental_article_keywords %>%
  slice_head(n = 20) %>%
  ggplot(aes(label = keywords, size = n, col = n)) +
  geom_text_wordcloud() +
  theme_void() +
  scale_color_gradient(low = "#c3af87", high = "#ffcc66")

dental_title_wordcloud <- dental_title_keywords %>%
  slice_head(n = 20) %>%
  ggplot(aes(label = keywords, size = n, col = n)) +
  geom_text_wordcloud() +
  theme_void() +
  scale_color_gradient(low = "#c3af87", high = "#ffcc66")

# titles_plot + bioarch_title_wordcloud / dental_title_wordcloud + plot_layout(ncol = 2)
# 
# articles_plot + bioarch_article_wordcloud / dental_article_wordcloud + plot_layout(ncol = 2)
# 
# articles_plot + 
#   inset_element(dental_wordcloud, left = 0, bottom = 0.6, right = 0.4, top = 1, 
#                               align_to = 'full') +
# titles_plot +
#   inset_element(bioarch_wordcloud, left = 0.4, bottom = 0.6, 
#                 right = 1, top = 1, align_to = 'full') + plot_layout(guides = 'auto')

