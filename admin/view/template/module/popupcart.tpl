<?php echo $header; ?>
<div id="content">
  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
  </div>
  <?php if ($error_warning) { ?>
  <div class="warning"><?php echo $error_warning; ?></div>
  <?php } ?>
  <div class="box">
    <div class="heading">
      <h1><img src="view/image/module.png" alt="" /> <?php echo $heading_title; ?></h1>
      <div class="buttons">
        <a onclick="$('#form').append('<input type=hidden value=save_exit name=action />');$('#form').submit();" class="button"><?php echo $this->language->get('button_save_exit'); ?></a>
        <a onclick="$('#form').submit();" class="button"><?php echo $this->language->get('button_save'); ?></a>
        <a onclick="location = '<?php echo $cancel; ?>';" class="button"><?php echo $this->language->get('button_cancel'); ?></a>
      </div>
    </div>
    <div class="content">
      <form action="<?php echo $action; ?>" method="post" id="form">
       <div id="tabs" class="htabs"><a href="#tab_general"><?php echo $this->language->get('tab_general'); ?></a><a href="#tab_settings"><?php echo $this->language->get('tab_settings'); ?></a></div>
        <div id="tab_general">
          <table id="module" class="list">
              <thead>
                <tr>
                  <td class="left"><?php echo $this->language->get('entry_layout'); ?></td>
                  <td class="left"><?php echo $this->language->get('entry_position'); ?></td>
                  <td class="left"><?php echo $this->language->get('entry_status'); ?></td>
                  <td class="right"><?php echo $this->language->get('entry_sort_order'); ?></td>
                  <td></td>
                </tr>
              </thead>
              <?php $module_row = 0; ?>
              <?php if( ! empty($modules) ): ?>
              <?php foreach ($modules as $module) { ?>
              <tbody id="module-row<?php echo $module_row; ?>">
                <tr>
                  <td class="left"><select name="popupcart_module[<?php echo $module_row; ?>][layout_id]">
                      <?php foreach ($layouts as $layout) { ?>
                      <?php if ($layout['layout_id'] == $module['layout_id']) { ?>
                      <option value="<?php echo $layout['layout_id']; ?>" selected="selected"><?php echo $layout['name']; ?></option>
                      <?php } else { ?>
                      <option value="<?php echo $layout['layout_id']; ?>"><?php echo $layout['name']; ?></option>
                      <?php } ?>
                      <?php } ?>
                    </select></td>
                  <td class="left"><select name="popupcart_module[<?php echo $module_row; ?>][position]">
                      <?php if ($module['position'] == 'content_top') { ?>
                      <option value="content_top" selected="selected"><?php echo $this->language->get('text_content_top'); ?></option>
                      <?php } else { ?>
                      <option value="content_top"><?php echo $this->language->get('text_content_top'); ?></option>
                      <?php } ?>
                      <?php if ($module['position'] == 'content_bottom') { ?>
                      <option value="content_bottom" selected="selected"><?php echo $this->language->get('text_content_bottom'); ?></option>
                      <?php } else { ?>
                      <option value="content_bottom"><?php echo $this->language->get('text_content_bottom'); ?></option>
                      <?php } ?>
                      <?php if ($module['position'] == 'column_left') { ?>
                      <option value="column_left" selected="selected"><?php echo $this->language->get('text_column_left'); ?></option>
                      <?php } else { ?>
                      <option value="column_left"><?php echo $this->language->get('text_column_left'); ?></option>
                      <?php } ?>
                      <?php if ($module['position'] == 'column_right') { ?>
                      <option value="column_right" selected="selected"><?php echo $this->language->get('text_column_right'); ?></option>
                      <?php } else { ?>
                      <option value="column_right"><?php echo $this->language->get('text_column_right'); ?></option>
                      <?php } ?>
                    </select></td>
                  <td class="left"><select name="popupcart_module[<?php echo $module_row; ?>][status]">
                      <?php if ($module['status']) { ?>
                      <option value="1" selected="selected"><?php echo $this->language->get('text_enabled'); ?></option>
                      <option value="0"><?php echo $this->language->get('text_disabled'); ?></option>
                      <?php } else { ?>
                      <option value="1"><?php echo $this->language->get('text_enabled'); ?></option>
                      <option value="0" selected="selected"><?php echo $this->language->get('text_disabled'); ?></option>
                      <?php } ?>
                    </select></td>
                  <td class="right"><input type="text" name="popupcart_module[<?php echo $module_row; ?>][sort_order]" value="<?php echo $module['sort_order']; ?>" size="3" /></td>
                  <td class="left"><a onclick="$('#module-row<?php echo $module_row; ?>').remove();" class="button"><?php echo $this->language->get('button_remove'); ?></a></td>
                </tr>
              </tbody>
              <?php $module_row++; ?>
              <?php } ?>
              <?php endif; ?>
              <tfoot>
                <tr>
                  <td colspan="4"></td>
                  <td class="left"><a onclick="addModule();" class="button"><?php echo $this->language->get('button_add_module'); ?></a></td>
                </tr>
              </tfoot>
            </table>
        </div>
        <div id="tab_settings">
          <table class="form">
            <tr>
              <td> <?php echo $this->language->get('text_popupcart_image_width'); ?> </td>
              <td> <input type="text" name="popupcart_image_width" value="<?php echo !empty($popupcart_image_width)? $popupcart_image_width : "100"; ?>" /> </td>
            </tr>
            <tr>
              <td> <?php echo $this->language->get('text_popupcart_image_height'); ?> </td>
              <td> <input type="text" name="popupcart_image_height" value="<?php echo !empty($popupcart_image_height)? $popupcart_image_height : "100"; ?>" /> </td>
            </tr>
            <tr>
              <td> <?php echo $this->language->get('text_popupcart_title_visible'); ?> </td>
              <td> 
                <select name="popupcart_title_visible" id="">
                  <option value="1" <?php echo $popupcart_title_visible?'selected="selected"':''; ?>>Да</option>
                  <option value="0" <?php echo $popupcart_title_visible==0?'selected="selected"':'';?>>Нет</option>
                </select>
              </td>
            </tr>
            <tr>
              <td> <?php echo $this->language->get('text_popupcart_title_text'); ?></td>
              <td> <input type="text" name="popupcart_title_text" value="<?php echo $popupcart_title_text; ?>" size="64" /> </td>
            </tr>
            <tr>
              <td> <?php echo $this->language->get('text_popupcart_title_draggable'); ?></td>
              <td>
                <select name="popupcart_title_draggable" id="">
                  <option value="1" <?php echo $popupcart_title_draggable?'selected="selected"':''; ?>>Да</option>
                  <option value="0" <?php echo $popupcart_title_draggable==0?'selected="selected"':''; ?>>Нет</option>
                </select>
              </td>
            </tr>
            <tr>
              <td> <?php echo $this->language->get('text_popupcart_xpath_trigger'); ?> </td>
              <td>
                <input type="text" name="popupcart_xpath_trigger" value="<?php echo $popupcart_xpath_trigger; ?>" size="64" >

                <?php if( ! empty($error_popupcart_xpath_trigger) ): ?>
                <br/>
                <span class="error"> <?php echo $error_popupcart_xpath_trigger; ?> </span>

                <?php endif; ?>
              </td>
            </tr>
          </table>
        </div>
      </form>
    </div>
  </div>
</div>
<script type="text/javascript"><!--
var module_row = <?php echo $module_row; ?>;

function addModule() {	
	html  = '<tbody id="module-row' + module_row + '">';
	html += '  <tr>';
	html += '    <td class="left"><select name="popupcart_module[' + module_row + '][layout_id]">';
	<?php foreach ($layouts as $layout) { ?>
	html += '      <option value="<?php echo $layout['layout_id']; ?>"><?php echo addslashes($layout['name']); ?></option>';
	<?php } ?>
	html += '    </select></td>';
	html += '    <td class="left"><select name="popupcart_module[' + module_row + '][position]">';
	html += '      <option value="content_top"><?php echo $this->language->get('text_content_top'); ?></option>';
	html += '      <option value="content_bottom"><?php echo $this->language->get('text_content_bottom'); ?></option>';
	html += '      <option value="column_left"><?php echo $this->language->get('text_column_left'); ?></option>';
	html += '      <option value="column_right"><?php echo $this->language->get('text_column_right'); ?></option>';
	html += '    </select></td>';
	html += '    <td class="left"><select name="popupcart_module[' + module_row + '][status]">';
    html += '      <option value="1" selected="selected"><?php echo $this->language->get('text_enabled'); ?></option>';
    html += '      <option value="0"><?php echo $this->language->get('text_disabled'); ?></option>';
    html += '    </select></td>';
	html += '    <td class="right"><input type="text" name="popupcart_module[' + module_row + '][sort_order]" value="" size="3" /></td>';
	html += '    <td class="left"><a onclick="$(\'#module-row' + module_row + '\').remove();" class="button"><?php echo $this->language->get('button_remove'); ?></a></td>';
	html += '  </tr>';
	html += '</tbody>';
	
	$('#module tfoot').before(html);
	
	module_row++;
}
//--></script> 
<script type="text/javascript"><!--
$('#tabs a').tabs(); 
//--></script> 
<?php echo $footer; ?>