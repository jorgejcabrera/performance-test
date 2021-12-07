package com.performance.test

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.boot.runApplication

@SpringBootApplication
@EnableConfigurationProperties
class SpringBootJdk11ServiceApplication

fun main(args: Array<String>) {
	runApplication<SpringBootJdk11ServiceApplication>(*args)
}
