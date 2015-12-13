// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){

  function setSubMenusMargin(){
    $('ol.sub-menus').css('margin-top', '0px');
    $('ol.sub-menus:has("li")').css('margin-top', '10px');
  }

  function olTag(){
    var tag = $('<ol></ol>');
    tag.addClass('sub-menus');
    return tag;
  }
  function addOrRemoveOl(li){
    if(li.find('li').length > 0) return;
    var parent = li.parents('ol').first();
    var hasOl = li.find('ol').length > 0;
    if(parent.hasClass('parent-menus')){
      if(!hasOl) li.append(olTag());
      li.removeData('subContainers');
    }else if(parent.hasClass('sub-menus')){
      li.find('ol').remove();
    }
  }

  var sortGroup = $('ol.sortMenu').sortable({
    group: 'menu',
    delay: 100,
    handle: 'i.glyphicon-move',
    onDrop: function ($item, container, _super) {
      addOrRemoveOl($item);
      setSubMenusMargin();

      var data = sortGroup.sortable("serialize").get();

      var jsonString = JSON.stringify(data, null, ' ');

      $('pre.output').text(jsonString);

      _super($item, container);
    },
    isValidTarget: function ($item, container) {
      // Can't move to sub-menu if it has sub-item.
      var hasChild = $item.find('li').length > 0;
      if(container.el.hasClass('sub-menus')){
        return !hasChild;
      }
      return true;
    }
  });
  setSubMenusMargin();
})
