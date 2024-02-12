use std::io::Write;

use crate::frb_generated::StreamSink;
use anyhow::{bail, Result};
use tracing_subscriber::{fmt::MakeWriter, EnvFilter};

struct LogSink {
    sink: StreamSink<String>
}

impl <'a> Write for &'a LogSink {
    fn write(&mut self, buf: &[u8]) -> std::io::Result<usize> {
        let line = String::from_utf8_lossy(buf).to_string();
        self.sink.add(line).unwrap();
        Ok(buf.len())
    }

    fn flush(&mut self) -> std::io::Result<()> {
        Ok(())
    }
}

impl<'a> MakeWriter<'a> for LogSink {
    type Writer = &'a LogSink;

    fn make_writer(&'a self) -> Self::Writer {
        self
    }
}

/// Public method that Dart will call into.
pub fn setup_logs(sink: StreamSink<String>) -> Result<()> {
    let log_sink = LogSink { sink };

    // Subscribe to tracing events and publish them to the UI
    if let Err(err) = tracing_subscriber::fmt()
        .with_max_level(tracing::Level::TRACE)
        .with_env_filter(EnvFilter::new("info,bolik_sdk=trace"))
        .with_writer(log_sink)
        .try_init()
    {
        bail!("{}", err);
    }
    Ok(())
}