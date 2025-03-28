FROM maven:3.8.5-openjdk-17 AS builder

WORKDIR /app

# 전체 프로젝트 복사
COPY . .

# Maven 빌드 시 npm 실행 건너뛰기
RUN mvn clean package -DskipTests -Dmaven.exec.skip=true

# Tomcat 배포 스테이지
FROM tomcat:10-jre17-temurin

# 빌드된 WAR 파일을 Tomcat의 webapps 디렉토리에 복사
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# 환경 변수 설정 부분 제거

EXPOSE 8080

CMD ["catalina.sh", "run"]