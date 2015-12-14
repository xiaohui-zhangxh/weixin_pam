// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){
  if($('body[data-page="diymenus_index"]')[0]) {
    var sortMenuEle, sortGroup, oldSortMenuResult, newSortMenuResult;

    $('form#form-sort-diymenu').on('ajax:success', function(data, status, xhr){
      switch(status.action){
        case 'upload':
          if(status.ok)
            appendFlashMessage('success', '上传成功');
          else
            appendFlashMessage('danger', '上传失败，失败原因：' + status.msg);
          break;
        case 'sort':
          initSortMenuResult();
          appendFlashMessage('success', '微信菜单保存成功');
          break;
        default:
          appendFlashMessage('success', '请求成功');
          break;
      }
    }).on('ajax:error', function(xhr, status, error){
      appendFlashMessage('danger', '请求失败');
    });

    $('a#upload-menu-to-weixin').click(function(e){
      if(oldSortMenuResult != newSortMenuResult){
        alert('上传前请先点击保存按钮，否则菜单不会被更新');
        e.preventDefault();
        return false;
      }
      return true;
    })

    function setSubMenusMargin() {
      $('ol.sub-menus').css('margin-top', '0px');
      $('ol.sub-menus:has("li")').css('margin-top', '10px');
    }

    function olTag() {
      var tag = $('<ol></ol>');
      tag.addClass('sub-menus');
      return tag;
    }

    function addOrRemoveOl(li) {
      if (li.find('li').length > 0) return;
      var parent = li.parents('ol').first();
      var hasOl = li.find('ol').length > 0;
      if (parent.hasClass('parent-menus')) {
        if (!hasOl) li.append(olTag());
        li.removeData('subContainers');
      } else if (parent.hasClass('sub-menus')) {
        li.find('ol').remove();
      }
    }

    function initSortMenuResult(){
      oldSortMenuResult = newSortMenuResult = JSON.stringify(sortGroup.sortable("serialize").get()[0], null, ' ');
    }

    sortMenuEle = $('ol.sortMenu');
    sortGroup = sortMenuEle.sortable({
      clear: true,
      group: 'menu',
      delay: 100,
      handle: 'i.fa.fa-arrows',
      onDrop: function ($item, container, _super) {
        addOrRemoveOl($item);
        setSubMenusMargin();

        var data = sortGroup.sortable("serialize").get();
        var jsonString = JSON.stringify(data, null, ' ');
        
        $('form#form-sort-diymenu input[name="state"]').val(jsonString);
        $('pre.output').text(jsonString);

        newSortMenuResult = JSON.stringify(data[0], null, ' ');
        console.log('newSortMenuResult=' + newSortMenuResult);
        _super($item, container);
      },
      isValidTarget: function ($item, container) {
        // 有3个主菜单,就不能再添加了
        if (container.el.hasClass('parent-menus') && container.items.length >= 3)
          return false;
        var hasChild = $item.find('li').length > 0;

        if (container.el.hasClass('sub-menus')) {
          // 如果菜单含有子菜单,就不能移动到其他子菜单里面
          if (hasChild) return false;
          // 子菜单最多只能 有五个
          if (container.items.length >= 5) return false;
        }

        return true;
      }
    });
    initSortMenuResult();
    setSubMenusMargin();
  }
})
