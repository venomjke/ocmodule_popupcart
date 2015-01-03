<?php

/**
 * Модуль всплывающей корзины
 *
 * @author alex.s <aleks.strigin@ya.ru>
 **/
class ControllerModulePopupCart extends Controller {

	private $version = '2.0';
		
	private $error = array();

	private $token = '';

	private $module_link = 'module/popupcart';

	public function __construct($registry)
	{
		parent::__construct($registry);

		$this->load->language('module/popupcart');

		$this->document->setTitle($this->language->get('heading_title'));
		$this->data['heading_title'] = $this->language->get('heading_title') . ' v' . $this->version;
	
		$this->token = $this->session->data['token'];
				
		$this->data['breadcrumbs'] = array();
		$this->data['lang'] = $this->language;

 		$this->data['breadcrumbs'][] = array(
     		'text'      => $this->language->get('text_home'),
				'href'      => $this->url->link('common/home', 'token=' . $this->token, 'SSL'),
    		'separator' => false
 		);

 		$this->data['breadcrumbs'][] = array(
     		'text'      => $this->language->get('text_module'),
				'href'   => $this->url->link('extension/module', 'token=' . $this->token, 'SSL'),
    		'separator' => ' :: '
 		);
	
 		$this->data['breadcrumbs'][] = array(
     		'text'      => $this->language->get('heading_title'),
				'href'      => $this->url->link($this->module_link, 'token=' . $this->token, 'SSL'),
    		'separator' => ' :: '
 		);				
	}

	public function index()
	{
		$action = isset($this->request->post['action'])?$this->request->post['action']:'save';

		$this->load->model('setting/setting');
				
		if ($this->is_post() && $this->validateForm()) {
			$this->model_setting_setting->editSetting('popupcart', $this->request->post);		
						
			$this->session->data['success'] = $this->language->get('text_success');
			
			if($action == 'save_exit'){
				$this->redirect($this->url->link('extension/module', 'token=' . $this->token, 'SSL'));
			} else {
				$this->redirect($this->url->link($this->module_link, 'token=' . $this->token, 'SSL'));
			}

		}
		

		$this->check_warnings();

		$this->check_errors();

		$this->data['action'] = $this->url->link($this->module_link, 'token=' . $this->token, 'SSL');
		
		$this->data['cancel'] = $this->url->link('extension/module', 'token=' . $this->token, 'SSL');
		
		$this->data['modules'] = array();
		
		$this->init_config_fields(array(
			'popupcart_module',
			'popupcart_image_width',
			'popupcart_image_height',
			
			'popupcart_title_draggable',

			'popupcart_title_text',			
			'popupcart_show_recommend',
			'popupcart_field_model',
			'popupcart_field_sku'
		));

		$this->data['modules'] = &$this->data['popupcart_module'];

		$this->load->model('design/layout');
		
		$this->data['layouts'] = $this->model_design_layout->getLayouts();

		$this->template = 'module/popupcart.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
	}

	public function install()
	{
		$this->load->model('setting/setting');

		$settings = array(
			'popupcart_image_width' => 100,
			'popupcart_image_height' => 100,
			'popupcart_title_text' => 'Корзина товаров',
			'popupcart_title_draggable' => 0,
			'popupcart_show_recommend' => 1,
			'popupcart_field_model'    => 1,
			'popupcart_field_sku'      => 1
		);

		$this->model_setting_setting->editSetting('popupcart',$settings);
	}

	public function uninstall()
	{
		$this->load->model('setting/setting');
		$this->model_setting_setting->deleteSetting('popupcart');	
	}

	private function init_config_fields(array $fields)
	{
		foreach($fields as $field){
			if (isset($this->request->post[$field])) {
				$this->data[$field] = $this->request->post[$field];
			} elseif ($this->config->get($field)) { 
				$this->data[$field] = $this->config->get($field);
			} else {
				$this->data[$field] = '';
			}
		}
	}

	private function validateForm() {
		if ( ! $this->user->hasPermission('modify', 'module/popupcart')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}

		if(!empty($this->error)){

			$error_msg = 'Во время сохранения возникли проблемы!';
			if(!empty($this->error['warning']))
				$this->error['warning'] .= '<br/>' . $error_msg;
			else
				$this->error['warning'] = $error_msg;
			return false;			
		}

		return true;
	}

	private function check_errors()
	{
	}

	private function check_warnings()
	{
 		if (isset($this->error['warning'])) {
			$this->data['error_warning'] = $this->error['warning'];
		} else {
			$this->data['error_warning'] = '';
		}
		
	}

	private function is_post(){
		return $this->request->server['REQUEST_METHOD'] == 'POST';
	} 

}