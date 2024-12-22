<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<form action="Write_process.jsp" method="post" enctype="multipart/form-data">

<div style=" flex-direction: row; display: flex; justify-content: space-between; padding: 20px;">
    <a href="Community.jsp">
        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="black" class="bi bi-x-lg" viewBox="0 0 16 16">
          <path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"/>
        </svg>
    </a>

    <button type="submit" style="background-color: lightsalmon; border-radius: 10px; border: none; height: 40px; align-items: center; width: 60px; align-content: center;">
        <span style="font-size: 18px;">등록</span>
    </button>
</div>

<div style="height: 50px;"></div>

<%-- 글쓰기 내용 입력 --%>

<div align="center" style="align-content: center;">
    <div style="flex-direction: column; display: flex; position: relative; width: 450px;">
        <p><input type="text" name="post_name" style="box-shadow: none; width: 450px; border-radius: 10px; border: 1px solid gray; height: 40px; background-color: #f5f5f5" placeholder=" 제목"></p>
        
        <!-- 파일 업로드 필드와 미리 보기 -->
        <div style="text-align: left;">
            <input type="file" name="postfile" id="postfile" style="display: none;" accept="image/*" onchange="displayPreview(event)">
            <!-- 아이콘을 클릭하여 파일 업로드 -->
            <label for="postfile" style="cursor: pointer; margin-top: 5px; display: inline-block;">
                <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-image" viewBox="0 0 16 16">
                  <path d="M6.002 5.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0"/>
                  <path d="M2.002 1a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V3a2 2 0 0 0-2-2zm12 1a1 1 0 0 1 1 1v6.5l-3.777-1.947a.5.5 0 0 0-.577.093l-3.71 3.71-2.66-1.772a.5.5 0 0 0-.63.062L1.002 12V3a1 1 0 0 1 1-1z"/>
                </svg>
            </label>
        </div>
        <div id="previewContainer" style="display: block; margin-top: 10px; text-align: center;">
            <img id="previewImage" src="" alt="미리 보기" style="width: 150px; height: 150px; border-radius: 10px; display: none; object-fit: contain; ">
        </div>
    </div>
</div>

<div style="height: 20px;"></div>

<div align="center" style="align-content: center;">
    <p><textarea rows="20" cols="30" placeholder=" 내용을 입력하세요" name="post" style="box-shadow: none; width: 450px; border-radius: 10px; border: 1px solid gray; align-items: center;"></textarea></p>
</div>
</form>

<script>
    function displayPreview(event) {
        const fileInput = event.target;
        const previewImage = document.getElementById('previewImage');

        // 파일이 선택된 경우 미리 보기 표시
        if (fileInput.files && fileInput.files[0]) {
            const reader = new FileReader();
            reader.onload = function (e) {
                previewImage.src = e.target.result;
                previewImage.style.display = 'block'; // 이미지 보이기
            };
            reader.readAsDataURL(fileInput.files[0]);
        }
    }
</script>
</body>
</html>