## Package Overview

The Opentelemetry Observability Extension is one of the tracing extensions of the<a target="_blank" href="https://ballerina.io/"> Ballerina</a> language.

It provides an implementation for tracing and publishing traces to a remote agent who can provide an API to publish tracing data.

## Enabling Opentelemetry Extension

To package the Opentelemetry extension into the Jar, follow the following steps.
1. Add the following import to your program.
```ballerina
import ballerinax/opentelemetry as _;
```

2. Add the following to the `Ballerina.toml` when building your program.
```toml
[package]
org = "my_org"
name = "my_package"
version = "1.0.0"

[build-options]
observabilityIncluded=true
```

To enable the extension and publish traces in Opentelemetry format to a reporter endpoint API, add the following to the `Config.toml` when running your program.
```toml
[ballerina.observe]
tracingEnabled=true
tracingProvider="opentelemetry"

[ballerinax.opentelemetry]
reporterEndpoint="<TRACE_API>"  # Required Configuration.
headers="<HEADER_KEY_1=HEADER_VALUE_1&HEADER_KEY_2=HEADER_VALUE_2>"             # Optional Configuration. Default value is "".
```
