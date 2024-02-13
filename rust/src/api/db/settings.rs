use flutter_rust_bridge::frb;
use serde::{Deserialize, Serialize};
use anyhow::Result;

use super::QuotientDb;

#[derive(Default, Serialize, Deserialize, Clone, Debug)]
pub enum Theme {
    #[default]
    System,
    Light,
    Dark,
    Amoled,
}

#[derive(Default, Serialize, Deserialize, Clone, Debug)]
pub enum FabSize {
    Small,
    #[default]
    Large,
}

#[derive(Default, Serialize, Deserialize, Clone, Debug)]
pub enum AccountStyle {
    #[default]
    Cards,
    Glass,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct ThemeSettings {
    pub app_color: u32,
    pub is_dynamic: bool,
    pub theme: Theme,
}

impl Default for ThemeSettings {
    #[allow(unconditional_recursion)]
    fn default() -> Self {
        ThemeSettings {
            app_color: 0xFF795548,
            ..Default::default()
        }
    }
    
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct Settings {
    pub theme: ThemeSettings,
    pub account_style: AccountStyle,
    pub fab_size: FabSize,
    pub biometrics_enabled: bool,
    pub language: String,
    pub calendar_format: String,
    pub font_family: String,
    pub currency: String,
    pub intro_completed: bool,
    // new settings must be appended to the end
    // to maintain backwards compatibility when deserializing
}

impl Default for Settings {
    #[allow(unconditional_recursion)]
    fn default() -> Self {
        Settings {
            language: "en".to_string(),
            calendar_format: "yyyy/MM/dd".to_string(),
            font_family: "Roboto".to_string(),
            currency: "EUR".to_string(),
            ..Default::default()
        }
    }
}

#[frb(opaque)]
pub struct SettingsRepository {
    db: SettingsProvider,
}

impl SettingsRepository {
    pub fn get_settings(&self) -> Settings {
        self.db.get(&"settings".to_string()).map(|(_, value)| value).unwrap_or_default()
    }

    pub fn set_settings(&self, settings: Settings) {
        self.db.put(&"settings".to_string(), &settings).unwrap();
    }
}

pub struct SettingsProvider {
    pub db: sled::Db,
}

impl QuotientDb for SettingsProvider {
    type Key = String;
    type Value = Settings;

    fn new(path: &str) -> Result<Self> where Self: Sized {
        let db = sled::open(path)?;
        Ok(SettingsProvider { db })
    }

    fn close(&self) -> () {
        self.db.flush().unwrap();
    }

    fn insert(&self, value: &Self::Value) -> Result<Self::Key> {
        let key = self.db.generate_id().unwrap().to_string();
        self.db.insert(key.clone(), bincode::serialize(value).unwrap())?;
        Ok(key)
    }

    fn put(&self, key: &Self::Key, value: &Self::Value) -> Result<()> {
        self.db.insert(key, bincode::serialize(value).unwrap())?;
        Ok(())
    }

    fn get(&self, key: &Self::Key) -> Option<(Self::Key, Self::Value)> {
        match self.db.get(key) {
            Ok(Some(value)) => Some((key.to_string(), bincode::deserialize(&value).unwrap())),
            _ => None,
        }
    }

    fn delete(&self, key: &Self::Key) -> Result<()> {
        self.db.remove(key)?;
        Ok(())
    }

    fn iter(&self) -> Box<dyn Iterator<Item = (Self::Key, Self::Value)> + '_> {
        Box::new(self.db.iter().map(|res| {
            let (key, value) = res.unwrap();
            (String::from_utf8(key.to_vec()).unwrap(), bincode::deserialize(&value).unwrap())
        }))
    }
}