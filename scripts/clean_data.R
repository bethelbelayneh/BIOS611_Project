library(tidyverse)
library(stringr)
library(stringi)
library(lubridate)

injuries <- read_csv('./source_data/injuries.csv')
fifa_data <- read_csv('./source_data/players_info.csv')

injuries <- injuries[injuries$Season %in% c('21/22', '22/23'), ]
fifa_tbl <- fifa_data %>% filter(league_name %in% c('Bundesliga', 'Serie A', 'Super Lig', 'Eredivisie', 
                                                              'Premier League', 'Ligue 1', 'La Liga', 'Premiership'))

fifa_tbl <- fifa_tbl %>%
  group_by(short_name, fifa_version) %>%
  arrange(fifa_update_date) %>%                     
  slice(1) %>%                                       
  ungroup()

fifa_tbl$fifa_version <- ifelse(
  fifa_tbl$fifa_version == 22, "21/22",
  ifelse(fifa_tbl$fifa_version == 23, "22/23", fifa_tbl$fifa_version)
)

fifa_tbl <- fifa_tbl %>%
  mutate(
    first_name = word(long_name, 1), 
    last_name = str_extract(short_name, "(?<=\\.)\\s*.+") %>% str_trim(),
    combined_name = paste(first_name, last_name)
  ) %>%
  select(-first_name, -last_name) 

fifa_tbl <- fifa_tbl %>%
  mutate(
    player_name = stri_trans_general(combined_name, "Latin-ASCII"),
    fifa_version = stri_trans_general(fifa_version, "Latin-ASCII")
  )

injuries <- injuries %>%
  mutate(
    player_name = stri_trans_general(player_name, "Latin-ASCII"),
    season = stri_trans_general(Season, "Latin-ASCII")
  )

injuries_tbl <- injuries %>% distinct() %>% select(-url_injuries)

data <- injuries_tbl %>%
  inner_join(
    fifa_tbl,
    by = c("season" = "fifa_version", 
           "player_name" = "player_name")
  )

unmerged_rows <- anti_join(injuries_tbl, fifa_tbl, 
                                    by = c("season" = "fifa_version",
                                           "player_name" = "player_name"))

second_merge <- inner_join(
  unmerged_rows, fifa_tbl,
  by = c('player_name' = 'short_name', 
         'season' = 'fifa_version')
)

data <- bind_rows(data, second_merge)

final_unmerged_rows <- anti_join(unmerged_rows, fifa_tbl,
                                  by = c('player_name' = 'short_name',
                                         'season' = 'fifa_version')
)

data <- data %>% select(-player_name.y, -league_level, -potential, -Season) %>% rename(
  games_missed = `Games missed`, 
  days_missed = Days,
  injury = Injury)

data <- data[, c(6, 7, 8, 1, 2, 3, 4, 5, 16, 17, 24, 25, 22, 20, 21, 13, 14, 15, 18, 19, 23, 9, 10, 11, 30, 26, 27, 28, 29)]

data$days_missed <- gsub(" days", "", data$days_missed)
data$days_missed <- as.numeric(data$days_missed)
data$games_missed <- as.numeric(data$games_missed)

data$from <- as.Date(data$from, format = "%b %d, %Y")
data$until <- as.Date(data$until, format = "%b %d, %Y")
str(data)

data <- data %>%
  mutate(month = month(from, label = TRUE, abbr = TRUE))

injury_categories <- list(
  `muscle injuries` = c(
    "hamstring injury", "muscle injury", "muscular problems", 
    "torn muscle fiber", "hamstring muscle injury", "hamstring strain", 
    "muscle strain", "muscle tear", "torn muscle bundle", 
    "torn muscle fiber in the adductor area", "strain in the thigh and gluteal muscles", 
    "muscle fiber tear", "muscle contusion", "partial muscle tear", "calf injury", "calf problems", 
    "calf muscle tear", "calf strain", "adductor pain", 
    "adductor injury", "adductor tear"
  ),
  `joint and ligament injuries` = c(
    "knee injury", "knee problems", "cruciate ligament tear", 
    "achilles tendon problems", "achilles tendon rupture", "ligament injury", 
    "inner ligament injury", "outer ligament problems", "collateral ligament injury", 
    "patellar tendon problems", "patellar tendon irritation", "patellar tendon rupture", 
    "inner ligament stretch of the knee", "ankle ligament tear", "cruciate ligament strain", 
    "ligament stretching", "partial damage to the cruciate ligament", 
    "syndesmotic ligament tear", "torn knee ligaments", "torn lateral knee ligament", 
    "torn lateral ankle ligament", "torn ligaments", "torn ankle ligaments", "ankle injury", "ankle problems"
  ),
  `bone injuries` = c(
    "metatarsal fracture", "broken ankle", "broken fibula", "fracture of fibula shaft", 
    "hairline crack in foot", "bone sprain", "broken arm", "broken jaw", 
    "broken tibia", "broken collarbone", "broken toe", "broken leg", 
    "broken hand", "broken thumb", "broken foot", "broken nose bone", 
    "broken finger", "scaphoid fracture", "femoral fracture", "forearm fracture", 
    "elbow fracture", "lower leg fracture", "lumbar vertebra fracture", 
    "fracture of frontal bone", "hairline fracture in the fibula", 
    "bone edema", "eyebow fracture", 
    "broken nose bone", "cervical spine injury"
  ),
  `bruises and contusions` = c(
    "ankle bruise", "bruise", "foot bruise", "shin bruise", "hip bruise", 
    "bruised ribs", "bruised back", "bruised knee", "pelvic contusion", 
    "crack bruise", "knock", "minor knock", "bruise on ankle", "bruise on shinbone", "bone bruise"
  ),
  `illnesses and infections` = c(
    "ill", "cold", "quarantine", "influenza", "flu", 
    "stomach flu", "fever", "tonsillitis", "pneumonia", 
    "intestinal virus", "malaria", "nerval disease", "shingles", 
    "appendicitis", "food poisoning", "mononucleation", "tooth infection", 
    "toothache", "bronchitis", "angina", "allergic reaction", "infection"
  ),
  coronavirus = c(
    "corona virus"
  ),
  surgeries = c(
    "knee surgery", "ankle surgery", "groin surgery", "achilles tendon surgery", 
    "foot surgery", "appendectomy", "nose surgery", "dental surgery", 
    "kidney stone surgery", "cruciate ligament surgery", "scaphoid surgery", 
    "lung contusion surgery"
  ),
  inflammation = c(
    "inflammation", "inflammation in the knee", "inflammation in the ankle joint", 
    "inflammation of ligaments in the knee", "inflammation of pubic bone", 
    "inflammation of the sole of the foot", "tendonitis", "achilles tendon irritation", 
    "edema in the knee", "tendon irritation"
  ),
  `head and neck injuries` = c(
    "concussion", "head injury", "neck injury", "nose injury"
  ),
  `stress and fatigue` = c(
    "stress reaction of the bone", "fatigue fracture”, “muscle fatigue", "sore muscles"
  ),
  `rest and fitness` = c(
    "rest", "fitness"
  ),
  miscellaneous = c(
    "unknown injury", "horse kiss", "contracture", 
    "open wound", "traffic accident", "flesh wound", "combustion", "laceration", 
    "laceration wound", "compression of the spine", "circulation problems", "depression", "heart problems"
  )
)

categorize_injury <- function(injury) {
  injury <- tolower(injury)  
  for (category in names(injury_categories)) {
    if (injury %in% injury_categories[[category]]) {
      return(category)
    }
  }
  return("uncategorized") # For injuries not listed above
}
data$injury_category <- sapply(tolower(data$injury), categorize_injury)

special_cases <- c(
  "Abdominal muscle strain", "Abdominal problems", "Achilles heel problems", 
  "Achilles tendon contusion", "Acromioclavicular joint dislocation", "Ankle sprain", "ankle sprain", 
  "Arch problems", "Arm injury", "Arthroscopy", "Back injury", "Back problems", 
  "Balance disorder", "Blood poisoning", "Bone marrow swelling", 
  "Broken cheekbone", "Broken kneecap", "Bursitis", "Calf stiffness", 
  "Capsular injury", "Cartilage damage", "Cerebral hemorrhage", "Chest injury", 
  "Collateral ligament tear", "contortion", "Cruciate ligament injury", "Cut", 
  "depression", "Dislocation fracture of the ankle joint", "Elbow injury", 
  "Eye injury", "Facial fracture", "Facial injury", "Finger injury", 
  "Fissure of the fibula", "Foot injury", "Groin injury", "Groin problems", 
  "Groin strain", "Hairline fracture in the muscles", "Hand injury", 
  "Heel injury", "Heel problems", "Heel spur", "Herniated disc", 
  "Hip flexor problems", "Hip injury", "Hip problems", "horse kiss",
  "Inflammation in the head of the fibula", "Inguinal hernia", 
  "Injury to abdominal muscles", "Injury to the ankle", "Inner knee ligament tear", 
  "Internal ligament strain", "Knee bruise", "Knee collateral ligament strain", 
  "Knee collateral ligament tear", "Knee medial ligament tear", 
  "Left hip flexor problems", "Leg injury", "Ligament tear", "Lumbago", 
  "Lumbar vertebra problems", "Lung contusion", "Meniscus damage", 
  "Meniscus injury", "Meniscus tear", "Metacarpal fracture", 
  "Metatarsal bruise", "muscle stiffness", "Outer ligament tear", 
  "Overstretching", "Partial patellar tendon tear", 
  "Patellar tendon dislocation", "Patellar tendon tear", "Pelvic injury", 
  "Pelvic obliquity", "Peroneus tendon injury", "pinched nerve", 
  "Pneumothorax", "Pubalgia", "Pubic bone bruise", "Pubic bone irritation", 
  "Rib fracture", "Right hip flexor problems", "Sciatica problems", 
  "Shin injury", "Shoulder injury", "Shoulder joint contusion", "sprain", 
  "stomach problems", "strain", "surgery", "Syndesmosis ligament tear", 
  "Tear of the lateral meniscus", "Tendon rupture", "Tendon tear", 
  "Testicular cancer", "Thigh problems", "Thumb injury", "Toe injury", 
  "Torn thigh muscle", "unknown injury", "Virus", "Wrist fracture", "Wrist injury"
)

data <- data %>%
  mutate(
    injury_category = ifelse(
      injury %in% special_cases,
      case_when(
        grepl("strain|tear|flexor|muscle|groin|calf|stiffness|abdominal", injury, ignore.case = TRUE) ~ "muscle injuries",
        grepl("ligament|bursitis|joint|dislocation|sprain|capsular|patellar|cruciate|syndesmosis|meniscus", injury, ignore.case = TRUE) ~ "joint and ligament injuries",
        grepl("fracture|bone|cheekbone|fibula|kneecap", injury, ignore.case = TRUE) ~ "bone injuries",
        grepl("bruise|contusion|hematoma|swelling", injury, ignore.case = TRUE) ~ "bruises and contusions",
        grepl("poisoning|virus|infection|depression|illness", injury, ignore.case = TRUE) ~ "illnesses and infections",
        grepl("Coronavirus", injury, ignore.case = TRUE) ~ "coronavirus",
        grepl("arthroscopy|surgery", injury, ignore.case = TRUE) ~ "surgeries",
        grepl("inflammation|irritation", injury, ignore.case = TRUE) ~ "inflammation",
        grepl("head|neck|cerebral|eye|facial|brain|balance", injury, ignore.case = TRUE) ~ "head and neck injuries",
        grepl("back|kiss|disc|vertebra", injury, ignore.case = TRUE) ~ "back injuries",
        grepl("unknown", injury, ignore.case = TRUE) ~ "unknown injuries",
        grepl("rest|fitness|overstretching|lumbago", injury, ignore.case = TRUE) ~ "rest and fitness",
        TRUE ~ "miscellaneous"
      ),
      injury_category 
    )
  )
data$injury_category<- ifelse(data$injury_category=="uncategorized", "muscle injuries", data$injury_category)

position_categories <- list(
  `other` = c(
    "SUB", "RES" 
  ),
  `goalkeepers` = c(
    "GK"
  ),
  `defenders` = c(
    "LCB", "RCB", "RB", "LB", "CB", "RWB", "LWB" 
  ),
  `midfielders` = c(
    "LCM", "RM", "LM", "RCM", "CAM", "CDM", "RDM", "LDM", "CM", "LAM", "RAM" 
  ),
  `forwards` = c(
    "ST", "RS", "LS", "RF", "LF", "CF", "RW", "LW"
  )
)

categorize_position <- function(position) {
  for (category in names(position_categories)) {
    if (position %in% position_categories[[category]]) {
      return(category)
    }
  }
  return("uncategorized") 
}

data$position_category <- sapply((data$club_position), categorize_position)

write_csv(data, "./derived_data/clean_data.csv")