<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.File, java.io.FileInputStream, java.io.IOException, java.io.OutputStream, java.util.Arrays, java.util.List" %>
<%
    String fileName = request.getParameter("file");

    // 파일 이름 검증: null, 빈 값, 혹은 `..` 포함 여부 확인
    if (fileName == null || fileName.isEmpty() || fileName.contains("..")) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        return;
    }

    // 허용된 파일 이름 목록 (예시). 필요에 따라 화이트리스트를 수정하거나 확장할 수 있습니다.
    List<String> allowedFiles = Arrays.asList("myfile.txt", "anotherfile.txt");
    if (!allowedFiles.contains(fileName)) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN); // 허용되지 않은 파일 접근 시 오류 처리
        return;
    }

    String filePath = "/files/" + fileName; // 파일 경로 설정
    File file = new File(getServletContext().getRealPath(filePath));
    
    if (!file.exists()) {
        response.sendError(HttpServletResponse.SC_NOT_FOUND);
        return;
    }

    String contentType = getServletContext().getMimeType(file.getAbsolutePath());
    if (contentType == null) {
        contentType = "application/octet-stream";
    }

    response.setContentType(contentType);
    response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

    try (FileInputStream fileInputStream = new FileInputStream(file);
         OutputStream outputStream = response.getOutputStream()) {

        byte[] buffer = new byte[4096];
        int bytesRead;
        while ((bytesRead = fileInputStream.read(buffer)) != -1) {
            outputStream.write(buffer, 0, bytesRead);
        }
    } catch (IOException e) {
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
%>
