<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <title>게시판 웹 사이트 - 검색 결과</title>
    
    <script>
        function openPopupPingTest() {
            var popup = window.open("pingTest2.jsp", "_blank", "width=600,height=400");
            popup.focus();
        }
        
        function openPopupFindUser() {
            var popup = window.open("finduser.jsp", "_blank", "width=600,height=400");
            popup.focus();
        }
    </script>

    <style type="text/css">
        a, a:hover {
            color: #000000;
            text-decoration: none;
        }
    </style>
</head>

<body>

<%!
    public static String escapeHtml(String input) {
        if (input == null) return null;
        return input.replaceAll("&", "&amp;")
                    .replaceAll("<", "&lt;")
                    .replaceAll(">", "&gt;")
                    .replaceAll("\"", "&quot;")
                    .replaceAll("'", "&#039;");
    }
%>

<% 
    String query = request.getParameter("query");
    if (query == null || query.isEmpty()) {
        response.sendRedirect("bbs.jsp");
        return;
    }

    String userID = (String) session.getAttribute("userID");
    int pageNumber = 1;
    if (request.getParameter("pageNumber") != null){
        pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
    }
    
    BbsDAO bbsDAO = new BbsDAO();
    ArrayList<Bbs> searchResult = bbsDAO.searchList(query, pageNumber);
%>

<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <a class="navbar-brand" href="main.jsp" style="margin-left: 10px;">검색결과</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNavDropdown">
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" href="main.jsp">🛖메인</a>
            </li>
            <li class="nav-item active">
                <a class="nav-link" href="bbs.jsp">📒게시판</a>
            </li>
            <% if (userID == null) { %>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-toggle="dropdown" aria-expanded="false">
                    접속하기
                </a>
                <ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
                    <li><a class="dropdown-item" href="login.jsp">로그인</a></li>
                    <li><a class="dropdown-item" href="join.jsp">회원가입</a></li>
                </ul>
            </li>
            <% } else { %>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    ⚙️회원관리
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
                    <a href="#" class="dropdown-item" onclick="openPopupFindUser(); return false;">🏕️유저찾기</a>
                    <a href="#" class="dropdown-item" onclick="openPopupPingTest(); return false;">📡인터넷 테스트</a>
                    <a class="dropdown-item" href="logoutAction.jsp">🤚로그아웃</a>
                </div>
            </li>
            <% } %>
        </ul>
    </div>
</nav>

<div class="row mt-4">
    <div class="col-md-6 offset-md-3">
        <h2 class="text-center">게시글 검색</h2>
        <form action="search.jsp" method="post" class="text-right mt-4">
            <div class="input-group">
                <input type="text" name="query" placeholder="  검색어를 입력하세요" class="form-control" value="<%= escapeHtml(query) %>">
                <div class="input-group-append">
                    <button type="submit" class="btn btn-primary">검색🔍</button>
                </div>
            </div>
        </form>
    </div>
</div>

<div class="row mt-4">
    <div class="col-md-6 offset-md-3">
        <h2 class="text-middle">검색 결과</h2>
        <p class="text-muted text-center">검색어: <%= escapeHtml(query) %></p>
        <table class="table table-bordered table-striped text-center">
            <thead>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>작성일</th>
                </tr>
            </thead>
            <tbody>
                <% for (Bbs bbs : searchResult) { %>
                <tr>
                    <td><%= bbs.getBbsID() %></td>
                    <td><a href="view.jsp?bbsID=<%= bbs.getBbsID() %>"><%= bbs.getBbsTitle() %></a></td>
                    <td><%= bbs.getUserID() %></td>
                    <td><%= bbs.getBbsDate().substring(0, 10) %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        
        <div class="text-center mt-4">
            <% if (pageNumber != 1) { %>
            <a href="search.jsp?query=<%= escapeHtml(query) %>&pageNumber=<%= pageNumber - 1 %>" class="btn btn-success btn-arrow-left">이전</a>
            <% } %>
            <% if (bbsDAO.nextPage(pageNumber + 1)) { %>
            <a href="search.jsp?query=<%= escapeHtml(query) %>&pageNumber=<%= pageNumber + 1 %>" class="btn btn-success btn-arrow-right">다음</a>
            <% } %>
        </div>
