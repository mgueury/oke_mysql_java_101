package com.mysql.web.basic.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "webquerydb.db")
public class DbProperties {

        private String url;	

        public String getUrl() {
                return url;
        }
        public void setUrl(String url) {
                this.url = url;
        }
}


