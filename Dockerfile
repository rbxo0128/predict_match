FROM maven:3.8.5-openjdk-17 AS builder

WORKDIR /app

# 전체 프로젝트 복사
COPY . .

# npm install 및 빌드 (tailwind CSS 처리를 위해)
RUN apt-get update && apt-get install -y nodejs npm
RUN npm install
RUN npm run build:css

# Maven 빌드
RUN mvn clean package -DskipTests

# Tomcat 배포 스테이지
FROM tomcat:10-jre17-temurin

# 빌드된 WAR 파일을 Tomcat의 webapps 디렉토리에 복사
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# 환경 변수 설정을 위한 파일 복사
COPY --from=builder /app/src/main/resources/.env /usr/local/tomcat/

EXPOSE 8080

CMD ["catalina.sh", "run"]