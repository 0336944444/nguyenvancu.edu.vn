function UTILS() {

    this.QueryString = function (key) {
        var strQuery = window.location.search.substring(1);
        var values = strQuery.split('&');
        for (i = 0; i < values.length; i++) {
            var value = values[i].split('=');
            if (value[0] == key) { return value[1]; }
        }
        return '';
    }

    this.InitPupils = function () {
        $("#listPupilHome li").removeClass("aui-tab-active aui-state-active");
        var __tab = this.QueryString('tab');
        switch (__tab) {
            case 'listclass':
                $('#aui_listclass').addClass('aui-tab-active aui-state-active');
                break;
            case 'pupils':
                $('#aui_pupils').addClass('aui-tab-active aui-state-active');
                break;
            case 'infomation':
                $('#aui_infomation').addClass('aui-tab-active aui-state-active');
                break;
            default:
                $('#aui_pupils').addClass('aui-tab-active aui-state-active');
                break;
        }
    }

    this.InitSchool = function () {
        $("#listSchoolHome li").removeClass("aui-tab-active aui-state-active");
        var __tab = this.QueryString('tab');
        switch (__tab) {
            case 'group':
                $('#aui_listGroup').addClass('aui-tab-active aui-state-active');
                break;
            case 'school':
                $('#aui_listScholl').addClass('aui-tab-active aui-state-active');
                break;
            default:
                $('#aui_listGroup').addClass('aui-tab-active aui-state-active');
                break;
        }
    }
    
    this.changeCheckState = function (chk) {
        var frm = document.forms[0];
        var i = 0;
        for (i = 0; i < frm.length; i++) {
            if (frm.elements[i].id.indexOf('chkItem') != -1) {
                if (document.getElementById(frm.elements[i].id) != null) {
                    if (chk.checked == true) {
                        if (frm.elements[i].checked == false) {
                            frm.elements[i].checked = true;
                        }
                    }
                    else {
                        if (frm.elements[i].checked == true) {
                            frm.elements[i].checked = false;
                        }
                    }

                }
            }
        }
    }

     this.CheckDelete = function() {
        var frm = document.forms[0];
        var count = 0;
        var i = 0;
        for (i = 0; i < frm.length; i++) {
            if (frm.elements[i].id.indexOf('chkItem') != -1) {
                if (document.getElementById(frm.elements[i].id) != null) {
                    if (frm.elements[i].checked == true) {
                        count = count + 1;
                    }
                }
            }
        }
        if (count > 0) {
            if (confirm('Bạn có muốn xóa các bản ghi được chọn')) {
                return true;
            }
            else {
                return false;
            }
        }
        else {
            alert('Chưa chọn bản ghi để xóa');
            return false;
        }
    }

    this.showDetail = function (DetailID) {
        var newwindow = window.open(DetailID, '', 'height=800,width=800');
        if (window.focus) {
            newwindow.focus();
        }
        return false;
    }

    this.showInfoDetail = function (__isTitle, __Title, __ClassID, __PupilID) {
        if (__isTitle == 1) {
            var newwindow = window.open('/Pages/PGD/PupilInfoDetail.aspx?tab=title&ClassID=' + __ClassID + '&Title=' + __Title, '', 'height=800,width=800');
            if (window.focus) {
                newwindow.focus();
            }
        }
        else {
            var newwindow = window.open('/Pages/PGD/PupilInfoDetail.aspx?tab=pupil&PupilID=' + __PupilID, '', 'height=800,width=800');
            if (window.focus) {
                newwindow.focus();
            }
        }
        return false;
    }

    this.tabActive = function (__link, __id) {
        var activeTab = '#' + __link;
        //aui-selected aui-state-active aui-tab-active current
        $("#aui_PupilsHome li").removeClass("aui-state-active");
        $("#aui_PupilsHome li").removeClass("aui-tab-active");
        $(__id).parent().parent().parent().addClass("aui-state-active");
        $(__id).parent().parent().parent().addClass("aui-tab-active");
        $(".tabContents").addClass("aui-helper-hidden");
        $(activeTab).removeClass("aui-helper-hidden");
        return false;
    }

    this.InitPupilsHome = function () {
        $("#aui_PupilsHome li").removeClass("aui-tab-active aui-state-active");
        var __tab = this.QueryString('tab');
        switch (__tab) {
            case 'pupil-list':
                $('#aui_tab_PupilsHome').addClass('aui-tab-active aui-state-active');
                break;
            case 'lookup-info':
                $('#aui_tab_PupilsInfo').addClass('aui-tab-active aui-state-active');
                break;
            default:
                $('#aui_tab_PupilsHome').addClass('aui-tab-active aui-state-active');
                break;
        }
    }



    this.choosevote = function (__value) {
        document.getElementById('hdVote').value = __value;
    }

    this.validateInputVote = function () {
        var __vote = $('#hdVote');
        if (__vote.val() == null || __vote.val() == '') {
            alert('Bạn chưa chọn câu trả lời bình chọn');
            return false;
        }
//        $.post("/WebParts/Comment/ajax/action.ashx", { __aa: 1, __voteid: __vote.val() },
//                function (data) {
//                    alert('Bình chọn thành công.');
//                });
        return true;
    }

    this.showVote = function () {
        var __survey = $('#surveyid');
        var __content = '<iframe src="/Pages/PGD/iframevote.aspx?id=' + __survey.val() + '" width="500px" height="250px" frameborder="0"></iframe>';
        var footer = '<input type="button" onclick=\'popup.hide()\' value="Đóng" />';
        popup.show(520, 280, 'Kết quả bình chọn', __content, footer, true);
        return false;
    }

    this.showformComment = function () {
        $('#form-feedback').toggleClass('aui-helper-hidden');
    }
}
var utils = new UTILS();


function POPUP() {
    this.showed = false;
    this.show = function (width, height, title, content, footer, isdrag) {
        $('#popup').css('margin-left', -width / 2);
        $('#popup').css('margin-top', -height / 2 - 40);
        $('#popup').width(width);
        $('#popup-content').height(height);
        $('#popup-title').text(title);
        $('#popup-content').html(content);
        $('#popup-footer').html(footer);
        //$('#shadow').fadeIn();
        $('#popup').fadeIn();
        if (isdrag)
            $("#popup").draggable();
        this.showed = true;
    }

    this.hide = function () {
        $('#popup-title').text('');
        $('#popup-content').html('');
        $('#popup-footer').html('');
        //$('#shadow').fadeOut();
        $('#popup').fadeOut();
        $("#popup").draggable("destroy");
        this.showed = false;
    }
    this.error = function (title, msg) {
        var content = '<div class=\'error\'>' + msg + '</div>';
        var footer = '<input type="button" class=\'button\' onclick=\'popup.hide()\' value="Đóng" />';
        this.show(250, 40, title, content, footer, false);
    }
    this.msg = function (width, height, title, msg) {
        var content = '<div class=\'msg\'>' + msg + '</div>';
        var footer = '<input type="button" class=\'button\' onclick=\'popup.hide()\' value="Đóng" />';
        this.show(width, height, title, content, footer, true);
    }
}
var popup = new POPUP();