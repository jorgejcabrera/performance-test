package com.performance.test.rest

import okhttp3.OkHttpClient
import okhttp3.Request
import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus.OK
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.time.Duration.ofMillis

@RequestMapping("/test")
@RestController
class TestController {

    @GetMapping
    fun getTestResource(): ResponseEntity<TestResource> {
        val client = OkHttpClient()
            .newBuilder()
            .readTimeout(ofMillis(5000))
            .writeTimeout(ofMillis(5000))
            .connectTimeout(ofMillis(5000))
            .build()
        val request = Request.Builder()
            .get()
            .url("http://wiremockserver:8080/wiremock_test")
            .build()
        try {
            client.newCall(request).execute()
        } catch (ex: Exception) {
            LOGGER.error("$ex")
            throw ex
        }
        return ResponseEntity
            .status(OK)
            .body(TestResource(1, "It is a stub response"))
    }

    companion object {
        @Suppress("JAVA_CLASS_ON_COMPANION")
        private val LOGGER = LoggerFactory.getLogger(javaClass.enclosingClass)
    }
}