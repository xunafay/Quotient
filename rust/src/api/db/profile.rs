use serde::{Deserialize, Serialize};
use anyhow::Result;
use tracing::{debug, info};
use flutter_rust_bridge::frb;

use super::QuotientDb;

#[derive(Serialize, Deserialize, Clone)]
pub struct Profile {
    pub image: Option<String>,
    pub name: Option<String>,
}


/// This method is called from Dart and sets up the profile repository.
pub fn create_profile_repository(db: ProfileProvider) -> ProfileRepository {
    ProfileRepository { db }
}

/// Opaque due to the sled::Db in ProfileProvider
#[frb(opaque)]
pub struct ProfileRepository {
    pub db: ProfileProvider,
}

impl ProfileRepository {
    pub fn set_image(&self, value: String) {
        debug!("setting profile image");
        self.db.put(&"image".to_string(), &value).unwrap();
    }

    pub fn set_name(&self, value: String) {
        debug!("setting profile name");
        self.db.put(&"name".to_string(), &value).unwrap();
    }

    pub fn get_profile(&self) -> Profile {
        debug!("getting profile");
        let image = self.db.get(&"image".to_string()).map(|(_, value)| value);
        let name = self.db.get(&"name".to_string()).map(|(_, value)| value);
        Profile { image, name }
    }
}

/// Opaque due to the sled::Db
#[frb(opaque)]
pub struct ProfileProvider {
    pub db: sled::Db,
}

pub fn open_profile_db(path: String) -> Result<ProfileProvider> {
    info!("Opening profile db at {}", path);
    let db = sled::open(path)?;
    Ok(ProfileProvider { db })
}

impl QuotientDb for ProfileProvider {
    type Key = String;
    type Value = String;

    fn new(path: &str) -> Result<Self> where Self: Sized {
        let db = sled::open(path)?;
        Ok(ProfileProvider { db })
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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_profile() {
        let db = open_profile_db("target/test_profile.db".to_string()).unwrap();
        let repo = ProfileRepository { db };
        repo.set_image("image".to_string());
        repo.set_name("name".to_string());
        let profile = repo.get_profile();
        assert_eq!(profile.image, Some("image".to_string()));
        assert_eq!(profile.name, Some("name".to_string()));
    }
}