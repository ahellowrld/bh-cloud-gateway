FROM  java:8

MAINTAINER zhangtao@bohailife.net

RUN mkdir -p /revisit

WORKDIR /revisit

EXPOSE 12021

ADD ./docker/revisit.jar ./app.jar
ADD ./src/main/resources/template /home/revisit/template/

ENV TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-Dlog4j2.formatMsgNoLookups=true", "-Dspring.profiles.active=prd" , "-Djasypt.encryptor.password=X@werls234N%" , "-Xms384m","-Xmx384m","-Xss256k","-XX:ParallelGCThreads=20","-XX:NewSize=192m","-XX:+UseConcMarkSweepGC", "-XX:+UseParNewGC", "-XX:MaxPermSize=192m",  "-Ddruid.filters=mergeStat" , "-Ddruid.useGlobalDataSourceStat=true" , "-jar", "app.jar"]

#CMD ["--spring.profiles.active=prd","--server.port=12021","-Ddruid.filters=mergeStat","-Ddruid.mysql.usePingMethod=false","-Ddruid.useGlobalDataSourceStat=true"]

#健康检查接口
HEALTHCHECK --interval=20s --timeout=3s --retries=10 CMD curl -X GET 127.0.0.1:12021/health/check || exit 1
