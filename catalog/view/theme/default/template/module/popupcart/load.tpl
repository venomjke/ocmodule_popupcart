<?php $lang = $this->language; ?>
<div id="cart">
  <div>
    <?php if ($products || $vouchers) { ?>
    <div class="mini-cart-info cart-info">
      <table class="popupcart-table">
        <thead>
            <tr>
                <td class="image"><?php echo $lang->get('popupcart_image') ?></td>
                <td class="name"><?php echo $lang->get('popupcart_name') ?></td>

                <?php if ($popupcart_field_model): ?>
                <td class="model"><?php echo $lang->get('popupcart_model'); ?></td>                  
                <?php endif; ?>

                <?php if ($popupcart_field_sku): ?>
                <td class="sku"><?php echo $lang->get('popupcart_sku'); ?></td>                  
                <?php endif ?>

                <td class="price"><?php echo $lang->get('popupcart_price'); ?></td>
                <td class="quantity"><?php echo $lang->get('popupcart_quantity'); ?></td>
                <td class="subtotal"><?php echo $lang->get('popupcart_subtotal'); ?></td>
                <td class="delete"><?php echo $lang->get('popupcart_delete'); ?></td>
            </tr>
        </thead>
        <?php foreach ($products as $product) { ?>
        <tr>
          <td class="image">
            <?php if ($product['thumb']) { ?>
            <a href="<?php echo $product['href']; ?>">
              <img src="<?php echo $product['thumb']; ?>" alt="<?php echo $product['name']; ?>" title="<?php echo $product['name']; ?>" /></a>
            <?php } ?></td>
          <td class="name">
            <a href="<?php echo $product['href']; ?>"><?php echo $product['name']; ?></a>
            <div>
              <?php foreach ($product['option'] as $option) { ?>
              - <small><?php echo $option['name']; ?> <?php echo $option['value']; ?></small><br />
              <?php } ?>
            </div>
          </td>

          <?php if ($popupcart_field_model): ?>
          <td class="model">
            <?php echo $product['model']; ?>
          </td>
          <?php endif; ?>

          <?php if ($popupcart_field_sku): ?>
          <td class="sku">
            <?php echo $product['sku']; ?>
          </td>
          <?php endif ?>

          <td class="price">
            <?php echo $product['price'] ?>
          </td>
          <td class="quantity">
            <input hidden="" class="product_id" value="<?php echo $product['key'] ?>" style="display:none;">
            <a onclick="modPopupCart.downQuantity(this);" class="quantity-m">-</a>
            <input value="<?php echo $product['quantity']; ?>" name="quantity" class="qt" size="1" onchange="modPopupCart.changeQuantity(this);" maxlength="4" onkeyup="modPopupCart.changeQuantity(this);">
            <a onclick="modPopupCart.upQuantity(this);" class="quantity-p">+</a>
          </td>
          <td class="total"><?php echo $product['total']; ?></td>
          <td class="remove">
            <img src="catalog/view/theme/default/image/remove-small.png" alt="<?php echo $button_remove; ?>" title="<?php echo $button_remove; ?>" onclick="modPopupCart.removeProduct('<?php echo $product['key']; ?>');" />
          </td>
        </tr>
        <?php } ?>
        <?php foreach ($vouchers as $voucher) { ?>
        <tr>
          <td class="image"></td>
          <td class="name"><?php echo $voucher['description']; ?></td>
          <td class="quantity">x&nbsp;1</td>
          <td class="total"><?php echo $voucher['amount']; ?></td>
          <td class="remove"><img src="catalog/view/theme/default/image/remove-small.png" alt="<?php echo $button_remove; ?>" title="<?php echo $button_remove; ?>" onclick="modPopupCart.removeVoucher(<?php echo $voucher['key'];?>);" /></td>
        </tr>
        <?php } ?>
        <tr class="popupcart-table-total">
          <td colspan="8">
          <?php foreach ($totals as $total) { ?>
            <div class="<?php echo $total['code']; ?>">
             <b><?php echo $total['title']; ?>:</b>
              <?php echo $total['text']; ?>            
            </div>
          <?php } ?>
          </td>
        </tr>
        <tfoot>
          <tr>
            <td colspan="8">
              <a onclick="modPopupCart.close();" class="button"><?php echo $lang->get('button_continue') ?></a>        
              <a href="<?php echo $checkout; ?>" class="button checkout"><?php echo $lang->get('button_checkout'); ?></a>        
            </td>
          </tr>
        </tfoot>
      </table>
    </div>
    <?php } else { ?>
     <div class="empty"><?php echo $lang->get('popupcart_empty'); ?></div>
    <?php } ?>
  </div>
</div>

  <?php if ($popupcart_show_recommend && ! empty($products_related)): ?>
    <div class="popupcart-recommend">
      <div id="popupcart-recommend-title"><?php echo $popupcart_title_recommend; ?></div>
      <div id="popupcart-carousel">
        <ul class="jcarousel-skin-opencart">
            <?php foreach ($products_related as $product): ?>
              <li>
                <div class="name">
                  <a href="<?php echo $product['href']; ?>" title="<?php echo $product['name']; ?>"><?php echo $product['name']; ?></a>
                </div>
                <div>
                  <div class="image">
                    <a href="<?php echo $product['href'] ?>"><img src="<?php echo $product['image']; ?>" alt="<?php echo $product['name']; ?>" /></a>
                  </div>
                  <div class="description">
                    <?php echo $product['description']; ?> ...
                  </div>                  
                </div>
                <div class="block">
                  <div class="price">
                    <?php echo $product['price']; ?>
                  </div>
                  <div class="cart">
                    <input type="button" value="Купить" class="button" onclick="addToCart(<?php echo $product['product_id']; ?>)" />
                  </div>
                </div>
              </li>
            <?php endforeach ?>        
        </ul>
      </div>
      <script type="text/javascript"><!--
      $('#popupcart-carousel ul').jcarousel({
        vertical: false,
        // visible: 2,
        scroll: 1
      });
      //--></script>
    </div>
  <?php endif ?>