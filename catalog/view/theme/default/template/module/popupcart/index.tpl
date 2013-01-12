<div id="popupcart" class="popupcart">
	<?php if($popupcart_title_visible): ?>
  <div class="title"><?php echo $popupcart_title_text; ?><a class="close" href=""; onclick="return modPopupCart.close();">
    <img src="catalog/view/theme/default/image/close.png" width="11" height="11" alt="" class="close"/></a>
  </div>
	<?php endif; ?>
  <div class="popupcart_content"></div>
</div>
<script type="text/javascript">
	$(function(){
		modPopupCart.init(<?php echo json_encode($config) ?>);
	});
</script>