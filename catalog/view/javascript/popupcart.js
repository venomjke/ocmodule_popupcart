(function($){

	var modPopupCart = {};

	// URI для загрузки содержимого корзины
	var popupCartUri = 'index.php?route=module/popupcart/load';
	// URI страницы оформления заказ
	var cartCheckoutUri = 'index.php?route=checkout/cart';

	// div
	var popupCartContainer = '#popupcart';
	var popupCartTitle = 'div.title';
	var popupCartContent = '#popupcart .popupcart_content';

	/*
	* Инициализация контейнера
	*/
	modPopupCart.init = function(config){
		var defConf = {};
		var $this = this;

		defConf = {
			draggable : "1",
		};

		config = $.extend({},defConf,config);

		// Настройка эффекта draggable
		if( parseInt(config.draggable) == 1 ){
			$(popupCartContainer).draggable({ handle: popupCartTitle });
		}

		$(popupCartContainer).disableSelection();
		$(popupCartContainer).resizable({
			maxHeight: 800,
			maxWidth: 800,
			minHeight: 530,
			minWidth: 600,
			alsoResize: popupCartContent
		});
		$(popupCartContent).resizable();

		// Останавливаем дальншейшее всплытие события "click" при клике на область окна
		$(popupCartContainer).click(function(event){
			event.stopPropagation();
		});

		// по клику на область вне окна корзины закрываем окно
		$('body').click(function(){
			$this.close();
		});

		$('body').keydown(function(event){
			if(event.which == 27) { // ESC 
				$this.close();
			}
		});		
	};

	/*
	* Открытие окна корзины
	*/
	modPopupCart.open = function(){
		$(popupCartContent).load(popupCartUri,{},function(){
			$(popupCartContainer).css('top', $(window).height()/2-$(popupCartContainer).height()/2);
			$(popupCartContainer).css('left', $(window).width()/2-$(popupCartContainer).width()/2);
			$(popupCartContainer).css("position","fixed");
			$(popupCartContainer).show();	
		});
		
		return false;
	};

	/*
	* Закрытие окна корзины
	*/
	modPopupCart.close = function(){
		$(popupCartContainer).hide();
		$(popupCartContent).empty();
		return false;
	};

	/*
	* Удаление товарной позиции
	*/
	modPopupCart.removeProduct = function(productId){
		if(getURLVar('route') == 'checkout/cart' || getURLVar('route') == 'checkout/checkout') {
			location = cartCheckoutUri + '&remove=' + productId;
		} else {
			$(popupCartContent).load(popupCartUri + '&remove=' + productId);
		}
	}

	/*
	* Удаление ваучера
	*/
	modPopupCart.removeVoucher = function(voucherId){
		if(getURLVar('route') == 'checkout/cart' || getURLVar('route') == 'checkout/checkout') {
			location = cartCheckoutUri + '&remove=' + voucherId;
		} else {
			$(popupCartContent).load(popupCartUri+'&remove=' + voucherId);
		}
	}

	window.modPopupCart = modPopupCart;

})($);
