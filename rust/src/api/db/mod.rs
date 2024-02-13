use anyhow::Result;

pub mod profile;
pub mod settings;

pub trait QuotientDb {
    type Key: Clone + PartialEq + Eq + serde::Serialize + serde::de::DeserializeOwned + Send + Sync + 'static;
    type Value: Clone + serde::Serialize + serde::de::DeserializeOwned + Send + Sync + 'static;

    fn new(path: &str) -> Result<Self> where Self: Sized;
    fn close(&self);
    fn insert(&self, value: &Self::Value) -> Result<Self::Key>;
    fn put(&self, key: &Self::Key, value: &Self::Value) -> Result<()>;
    fn get(&self, key: &Self::Key) -> Option<(Self::Key, Self::Value)>;
    fn delete(&self, key: &Self::Key) -> Result<()>;
    fn iter(&self) -> Box<dyn Iterator<Item = (Self::Key, Self::Value)> + '_>;
}