@echo off
REM Maven Wrapper startup script for Windows
setlocal

set "MAVEN_PROJECTBASEDIR=%~dp0"
set "MAVEN_WRAPPER_JAR=%MAVEN_PROJECTBASEDIR%.mvn\wrapper\maven-wrapper.jar"

if exist "%MAVEN_WRAPPER_JAR%" (
    java -jar "%MAVEN_WRAPPER_JAR%" %*
) else (
    echo Maven wrapper jar not found. Please install Maven or download the wrapper jar.
    echo You can run: mvn wrapper:wrapper
    exit /b 1
)
