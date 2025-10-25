<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
  #google_translate_element {
    display: inline-block;
    margin: 10px;
    display: block;       /* block so text-align works */
    text-align: right; 
  }

  .goog-te-gadget-simple {
    background-color: #f8f9fa !important;
    border: 1px solid #ccc !important;
    border-radius: 6px;
    padding: 5px 10px;
    font-family: 'Segoe UI', sans-serif !important;
    color: #333 !important;
    display: inline-flex;
    align-items: center;
  }

  .goog-te-gadget-simple img {
    display: none; /* Hide Google icon if you want */
  }

  .goog-te-gadget-simple span {
    color: #333 !important;
    font-size: 14px !important;
  }
  
  body{
  background-color: #00274d;
  align: right;}
</style>

</head>
<body>

<!-- Google Translate Element -->
<div id="google_translate_element"></div>

<script type="text/javascript">
  function googleTranslateElementInit() {
    new google.translate.TranslateElement(
      {
        pageLanguage: 'en',          // Your site’s original language
        includedLanguages: 'en,si,ta', // Optional: restrict languages (English, Sinhala, Tamil)
        layout: google.translate.TranslateElement.InlineLayout.SIMPLE
      },
      'google_translate_element'
    );
  }
</script>

<!-- Google Translate Script -->
<script type="text/javascript" 
  src="https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit">
</script>

<!-- Optional Styling -->


</body>
</html>