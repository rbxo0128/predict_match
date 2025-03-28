# 빌드 스테이지
FROM maven:3.8.5-openjdk-17 AS builder

WORKDIR /app

# Node.js와 npm 설치
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Maven 의존성 레이어를 별도로 캐싱
COPY pom.xml .
COPY .mvn .mvn
RUN mvn dependency:go-offline

# Tailwind CSS 빌드 준비
COPY package.json .
COPY tailwind.config.js .
RUN npm install

# 소스 코드 복사
COPY src src
COPY mvnw mvnw
COPY mvnw.cmd mvnw.cmd

# 애플리케이션 빌드 (Tailwind CSS 빌드 포함)
RUN npm run build:css && mvn clean package -DskipTests

# 런타임 스테이지
FROM tomcat:10-jre17-temurin

# 빌드된 WAR 파일을 Tomcat의 webapps 디렉토리에 복사
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# 환경 변수 설정을 위한 파일 복사
COPY --from=builder /app/src/main/resources/.env /usr/local/tomcat/

# 포트 설정
EXPOSE 8080

# Tomcat 실행
CMD ["catalina.sh", "run"]