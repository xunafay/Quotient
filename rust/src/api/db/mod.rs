use anyhow::Result;

pub mod db;

pub trait QuotientDb {
    type Key: Clone + PartialEq + Eq + std::fmt::Debug + serde::Serialize + serde::de::DeserializeOwned + Send + Sync + 'static;
    type Value: Clone + PartialEq + Eq + std::fmt::Debug + serde::Serialize + serde::de::DeserializeOwned + Send + Sync + 'static;

    fn new(path: &str) -> Result<Self> where Self: Sized;
    fn close(&self);
    fn insert(&self, value: &str) -> Result<Self::Key>;
    fn put(&self, key: &str, value: &str) -> Result<()>;
    fn get(&self, key: &str) -> Option<(Self::Key, Self::Value)>;
    fn delete(&self, key: &str) -> Result<()>;
    fn iter(&self) -> Box<dyn Iterator<Item = (Self::Key, Self::Value)> + '_>;
}