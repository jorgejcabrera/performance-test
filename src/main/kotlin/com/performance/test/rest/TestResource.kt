package com.performance.test.rest

import com.fasterxml.jackson.annotation.JsonProperty

data class TestResource(
    @field:JsonProperty("id") val id: Long,
    @field:JsonProperty("description") val description: String
)