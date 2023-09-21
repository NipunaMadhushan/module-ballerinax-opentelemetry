// Copyright (c) 2023, WSO2 LLC. (https://www.wso2.com) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;
import ballerina/jballerina.java;
import ballerina/observe;
import ballerina/regex;

const PROVIDER_NAME = "opentelemetry";
const DEFAULT_SAMPLER_TYPE = "const";

configurable string reporterEndpoint = "";
configurable string headers = "";
configurable string samplerType = "const";
configurable decimal samplerParam = 1;
configurable int reporterFlushInterval = 1000;
configurable int reporterBufferSize = 10000;

function init() {
    if (observe:isTracingEnabled() && observe:getTracingProvider() == PROVIDER_NAME) {
        string selectedSamplerType;
        if (samplerType != "const" && samplerType != "ratelimiting" && samplerType != "probabilistic") {
            selectedSamplerType = DEFAULT_SAMPLER_TYPE;
            io:println("error: invalid Opentelemetry configuration sampler type: " + samplerType
                                               + ". using default " + DEFAULT_SAMPLER_TYPE + " sampling");
        } else {
            selectedSamplerType = samplerType;
        }

        map<string> headersMap = {};
        if (headers != "") {
            string[] headersArray = regex:split(headers, "&");

            foreach string header in headersArray {
                string[] headerKeyValuePair = regex:split(header, "=");
                if ( headerKeyValuePair.length() == 2) {
                    headersMap[headerKeyValuePair[0]] = headerKeyValuePair[1];
                } else {
                    io:println("error: invalid Opentelemetry configuration header format");
                }
            }
        }

        externInitializeConfigurations(reporterEndpoint, headersMap, selectedSamplerType, samplerParam,
            reporterFlushInterval, reporterBufferSize);
    }
}

function externInitializeConfigurations(string reporterEndpoint, map<string> headers, string samplerType,
        decimal samplerParam, int reporterFlushInterval, int reporterBufferSize) = @java:Method {
    'class: "io.ballerina.observe.trace.opentelemetry.OpentelemetryTracerProvider",
    name: "initializeConfigurations"
} external;
