<div id="popupcart-bg">
</div>
	<div id="popupcart" class="popupcart" style="z-index:1000">
	  <div class="title">
  		<a class="close" href=""; onclick="return modPopupCart.close();">
	    	<img src="/image/popupcart/carousel-close.png" class="close"/>
	    </a>
		<h4 class="heading"><?php echo $heading_title; ?></h4>
	  </div>
	  <div class="popupcart_content"></div>
	</div>
<script type="text/javascript">
	$(function(){
		modPopupCart.init(<?php echo json_encode($config) ?>);
	});
</script>