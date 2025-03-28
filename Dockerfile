# 빌드 스테이지
FROM maven:3.8.5-openjdk-17 AS builder

WORKDIR /app

# Maven 의존성 레이어를 별도로 캐싱
COPY pom.xml .
COPY .mvn .mvn
RUN mvn dependency:go-offline

# 소스 코드 복사 및 Tailwind CSS 빌드
COPY package.json package.json
COPY tailwind.config.js tailwind.config.js
RUN npm install

# 소스 코드 복사
COPY src src
COPY mvnw mvnw
COPY mvnw.cmd mvnw.cmd

# 애플리케이션 빌드
RUN npm run build:css && mvn clean package -DskipTests

# 런타임 스테이지
FROM tomcat:10-jre17-temurin

# Tomcat 사용자로 실행 (보안 강화)
USER root
RUN groupadd -r tomcatuser && useradd -r -g tomcatuser tomcatuser
RUN chown -R tomcatuser:tomcatuser /usr/local/tomcat

# 빌드된 WAR 파일을 Tomcat의 webapps 디렉토리에 복사
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# 환경 변수 설정을 위한 파일 복사
COPY --from=builder /app/src/main/resources/.env /usr/local/tomcat/

# 권한 변경
RUN chmod -R 755 /usr/local/tomcat/webapps
USER tomcatuser

# 포트 설정
EXPOSE 8080

# Tomcat 실행
CMD ["catalina.sh", "run"]