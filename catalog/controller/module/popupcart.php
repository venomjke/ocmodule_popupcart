<?php
class ControllerModulePopupCart extends Controller {

	/*
	* Вывод формы всплывающей корзины
	*/
	protected function index($setting) {

		$this->language->load('module/popupcart');

		$this->data['heading_title'] = $this->config->get('popupcart_title_text');

		$this->data['config'] = array();

		$this->data['popupcart_title_text'] = $this->config->get('popupcart_title_text');

		$this->data['config']['draggable'] = $this->config->get('popupcart_title_draggable');

		if( file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/stylesheet/popupcart.css') ){
			$this->document->addStyle('catalog/view/theme/' . $this->config->get('config_template') . '/stylesheet/popupcart.css');
		} else {
			$this->document->addStyle('catalog/view/theme/default/stylesheet/popupcart.css');
		}

		$this->document->addScript('catalog/view/javascript/products.jcarousel.js');
		$this->document->addScript('catalog/view/javascript/popupcart.js');

		if ( file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/module/popupcart/index.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/module/popupcart/index.tpl';
		} else {
			$this->template = 'default/template/module/popupcart/index.tpl';
		}

		$this->render();
	}

	/*
	* Загрузка содержимого корзины
	*/
	public function load()
	{
		if( ! $this->is_ajax() ) $this->redirect($this->url->link('common/home'));

		$this->language->load('module/popupcart');

		// $this->language->load('module/cart');

		// Totals
		$this->load->model('setting/extension');
		$this->load->model('catalog/product');
		
		/*
		* delete product
		*/
	  	if (isset($this->request->get['remove'])) {
	    	$this->cart->remove($this->request->get['remove']);	
			unset($this->session->data['vouchers'][$this->request->get['remove']]);
	  	}	
		
		/*
		* update quantity product
		*/
		if (isset($this->request->get['update']) && isset($this->request->get['qty'])) {
	  		$this->cart->update($this->request->get['update'], $this->request->get['qty']);
	  	}			

		$this->data['popupcart_show_recommend']  = $this->config->get('popupcart_show_recommend');
		$this->data['popupcart_field_sku']  = $this->config->get('popupcart_field_sku');
		$this->data['popupcart_field_model']= $this->config->get('popupcart_field_model');


		$total_data = array();
		$total = 0;
		$taxes = $this->cart->getTaxes();

		$popupcart_image_width = $this->config->get('popupcart_image_width');
		$popupcart_image_height= $this->config->get('popupcart_image_height');
		
		// Display prices
		if ( ($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price') ) {
			$sort_order = array(); 
			
			$results = $this->model_setting_extension->getExtensions('total');
			
			foreach ($results as $key => $value) {
				$sort_order[$key] = $this->config->get($value['code'] . '_sort_order');
			}
			
			array_multisort($sort_order, SORT_ASC, $results);
			
			foreach ($results as $result) {
				if ($this->config->get($result['code'] . '_status')) {
					$this->load->model('total/' . $result['code']);
		
					$this->{'model_total_' . $result['code']}->getTotal($total_data, $total, $taxes);
				}
				
				$sort_order = array(); 
			  
				foreach ($total_data as $key => $value) {
					$sort_order[$key] = $value['sort_order'];
				}
	
				array_multisort($sort_order, SORT_ASC, $total_data);			
			}		
		}
		
		$this->data['totals'] = $total_data;
		
		$this->data['heading_title'] = $this->language->get('heading_title');
		
		$this->data['text_items'] = sprintf($this->language->get('text_items'), $this->cart->countProducts() + (isset($this->session->data['vouchers']) ? count($this->session->data['vouchers']) : 0), $this->currency->format($total));
		$this->data['text_empty'] = $this->language->get('text_empty');
		$this->data['text_cart'] = $this->language->get('text_cart');
		$this->data['text_checkout'] = $this->language->get('text_checkout');
		
		$this->data['button_remove'] = $this->language->get('button_remove');
		
		$this->load->model('tool/image');
		
		$this->data['products'] = array();
		$this->data['products_related'] = array();
			
		foreach ($this->cart->getProducts() as $product) {

			if($this->data['popupcart_show_recommend']){
				$related = $this->model_catalog_product->getProductRelated($product['product_id']);
				$this->data['products_related'] = array_merge($this->data['products_related'], $related);
			}

			if ($product['image']) {
				$image = $this->model_tool_image->resize($product['image'], $popupcart_image_width,$popupcart_image_height);
			} else {
				$image = '';
			}

			$product_info = $this->model_catalog_product->getProduct($product['product_id']);

			$option_data = array();
			
			foreach ($product['option'] as $option) {
				if ($option['type'] != 'file') {
					$value = $option['option_value'];	
				} else {
					$filename = $this->encryption->decrypt($option['option_value']);
					
					$value = utf8_substr($filename, 0, utf8_strrpos($filename, '.'));
				}				
				
				$option_data[] = array(								   
					'name'  => $option['name'],
					'value' => (utf8_strlen($value) > 20 ? utf8_substr($value, 0, 20) . '..' : $value),
					'type'  => $option['type']
				);
			}
			
			// Display prices
			if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
				$price = $this->currency->format($this->tax->calculate($product['price'], $product['tax_class_id'], $this->config->get('config_tax')));
			} else {
				$price = false;
			}
			
			// Display prices
			if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
				$total = $this->currency->format($this->tax->calculate($product['total'], $product['tax_class_id'], $this->config->get('config_tax')));
			} else {
				$total = false;
			}
													
			$this->data['products'][] = array(
				'key'      => $product['key'],
				'sku'	   => $product_info['sku'],
				'thumb'    => $image,
				'name'     => $product['name'],
				'model'    => $product['model'], 
				'option'   => $option_data,
				'quantity' => $product['quantity'],
				'price'    => $price,	
				'total'    => $total,	
				'href'     => $this->url->link('product/product', 'product_id=' . $product['product_id'])		
			);
		}

		foreach ($this->data['products_related'] as &$product) {

			if ($product['image']) {
				$image = $this->model_tool_image->resize($product['image'], 50, 50);
			} else {
				$image = '';
			}
			
			// Display prices
			if (($this->config->get('config_customer_price') && $this->customer->isLogged()) || !$this->config->get('config_customer_price')) {
				$price = $this->currency->format($this->tax->calculate($product['price'], $product['tax_class_id'], $this->config->get('config_tax')));
			} else {
				$price = false;
			}
						
			$product['image'] = $image;
			$product['price'] = $price;
			$product['href']  = $this->url->link('product/product', 'product_id=' . $product['product_id']);
			$product['description'] = mb_substr(html_entity_decode($product['description'], ENT_QUOTES, 'UTF-8'), 0, 90);

		}
		
		// Gift Voucher
		$this->data['vouchers'] = array();
		
		if ( ! empty($this->session->data['vouchers']) ) {
			foreach ($this->session->data['vouchers'] as $key => $voucher) {
				$this->data['vouchers'][] = array(
					'key'         => $key,
					'description' => $voucher['description'],
					'amount'      => $this->currency->format($voucher['amount'])
				);
			}
		}
					
		$this->data['cart'] = $this->url->link('checkout/cart');
						
		$this->data['checkout'] = $this->url->link('checkout/checkout', '', 'SSL');

		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/module/popupcart/load.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/module/popupcart/load.tpl';
		} else {
			$this->template = 'default/template/module/popupcart/load.tpl';
		}

		$this->response->setOutput($this->render());	
	}

	private function is_ajax()
	{
		return ! empty($this->request->server['HTTP_X_REQUESTED_WITH']) && strtolower($this->request->server['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest';
	}
}
?>