<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="cpath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Bootstrap Example</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function goSave(isbn){
            let authorsElement = document.getElementById("a" + isbn);
            let authors = authorsElement.textContent;

            let titleElement = document.getElementById("t" + isbn);
            let title = titleElement.textContent;

            let priceElement = document.getElementById("p" + isbn);
            let price = priceElement.textContent;
            const url = "${cpath}/restsave";

            fetch(url, {
                method:"POST",
                headers:{
                    "Content-Type":"application/json",
                },
                body:JSON.stringify({title,price,authors})
            })
                .then(response => response.text())
                .then(data=>{
                    console.log(data)
                    location.href="${cpath}/list";
                }).catch(error => {
                console.log(error)
            });
        }

        function showTitle(button){
            let row = button.closest("tr");
            let title = row.querySelector("td:nth-child(2)").textContent;
            document.getElementById("searchTitle").textContent="Selected Book Title:" + title;
            let url = "${cpath}/search/books?title=" + encodeURIComponent(title);
            fetch(url)
                .then(response => {
                   if(response.ok){
                       return response.json();
                   }
                   throw new Error("error");
                })
                .then(data =>{
                    console.log(data);
                    const resultsContainer = document.querySelector('#bookList');
                    resultsContainer.innerHTML='';
                    data.documents.forEach(book =>{
                        const { authors, title, price, isbn, publisher, thumbnail,  url} = book;
                        const bookInfo = document.createElement('div');
                        bookInfo.classList.add("book-info");
                        bookInfo.style.border='1px solid #ddd';
                        bookInfo.style.margin = '10px 0';
                        bookInfo.style.padding='10px';
                        var html="<table class='table'>";
                        html+="<tr>";
                        html += "<td>저자 <button type='button' class='btn btn-sm btn-success save-btn' onclick='goSave(\"" + isbn + "\")'>저장</button></td>";
                        html += "<td id='a" + isbn + "'>" + authors + "</td>";
                        html+="</tr>";
                        html+="<tr>";
                        html+="<td>제목</td>";
                        html+="<td id='t"+isbn+"'><a href="+url+">"+title+"</a></td>";
                        html+="</tr>";
                        html+="<tr>";
                        html+="<td>가격</td>";
                        html+="<td id='p"+isbn+"'>"+price+"</td>";
                        html+="</tr>";
                        html+="<tr>";
                        html+="<td>출판사</td>";
                        html+="<td id='pu"+isbn+"'>"+publisher+"</td>";
                        html+="</tr>";
                        html+="<tr>";
                        html+="<td colspan='2'><img src="+thumbnail+"/></td>";
                        html+="</tr>";
                        html+="</table>";
                        bookInfo.innerHTML=html;

                        //bookInfo.innerHTML=price+":"+isbn+":"+publisher+":" + "<a href='"+url+"'>"+title+"</a><img src=" + thumbnail + "/>"
                        resultsContainer.appendChild(bookInfo);
                    });
                })
                .catch(error => {
                   console.log(error);
                });
        }
    </script>
</head>
<body>

<div class="container-fluid mt-3">
    <h1>Java Spring Full Stack Developer</h1>
    <p>Resize the browser window to see the effect.</p>
    <p>The first, second and third row will automatically stack on top of each other when the screen is less than 576px wide.</p>

    <div class="container-fluid">

        <div class="card">
            <div class="card-header">Java Spring Framework</div>
            <div class="card-body">
                <div class="row">
                    <div class="col-sm-2 mb-2">
                        <div class="card">
                            <div class="card-body">
                                <h4 class="card-title">Left</h4>
                                <p class="card-text">Some example text. Some example text.</p>
                                <a href="#" class="card-link">Card link</a>
                                <a href="#" class="card-link">Another link</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-7 mb-2">
                        <div class="card">
                            <div class="card-body">
                                <h4 class="card-title">Book List</h4>
                                <p class="card-text">Show Book List</p>
                                <table class="table table-bordered table-hover">
                                    <thead>
                                    <tr>
                                        <th>NUMBER</th>
                                        <th>TITLE</th>
                                        <th>PRICE</th>
                                        <th>AUTHOR</th>
                                        <th>PAGE</th>
                                        <th>SEARCH</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="book" items="${list}">
                                        <tr>
                                            <td>${book.num}</td>
                                            <td><a href="${cpath}/get/${book.num}">${book.title}</a></td>
                                            <td>${book.price}</td>
                                            <td>${book.author}</td>
                                            <td>${book.page}</td>
                                            <td><button class="btn btn-sm btn-info" onclick="showTitle(this)">Search</button></td>
                                        </tr>
                                    </c:forEach>
                                    <button class="btn btn-sm-success">Register</button>
                                    </tbody>
                                </table>
                                <button class="btn btn-sm-success" onclick="location.href='${cpath}/register'">Register</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-3">
                        <div class="card">
                            <div class="card-body">
                                <h4 class="card-title">Result</h4>
                                <p class="card-text" id="searchTitle"></p>
                                <div id="bookList"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-footer text-center">Java Spring Full Stack Developer</div>
        </div>

    </div>
</div>

</body>
</html>