var Dialog = (function () {
    function Dialog() {
    }
    Dialog.removeEventHandler = function (elem, eventType, handler) {
        if (elem.removeEventListener)
            elem.removeEventListener(eventType, handler, false);
        if (elem.detachEvent)
            elem.detachEvent('on' + eventType, handler);
    };
    Dialog.addEventHandler = function (elem, eventType, handler) {
        if (elem.addEventListener)
            elem.addEventListener(eventType, handler, false);
        else if (elem.attachEvent)
            elem.attachEvent('on' + eventType, handler);
    };
    Dialog.Close = function () {
        try {
            var button = document.getElementById("closeDialogButton");
            button.onclick(null);
        }
        catch (error) { }
    };
    Dialog._close = function () {
        try {
            var dialog = document.getElementById("dialog");
            document.body.removeChild(dialog);
        }
        catch (error) { }
    };
    Dialog.AddElement = function (element) {
        var dialogBody = document.getElementById("dialogBody");
        dialogBody.appendChild(element);
    };
    Dialog.Alert = function (content, title, close_callback) {
        if (title === void 0) { title = ""; }
        if (close_callback === void 0) { close_callback = function () { }; }
        Dialog.Close();
        var dialog = document.createElement("div");
        dialog.id = "dialog";
        var dialogTitle = document.createElement("div");
        dialogTitle.id = "dialogTitle";
        var titleText = document.createElement("span");
        titleText.id = "titleText";
        titleText.innerHTML = title;
        var closeDialogButton = document.createElement("div");
        closeDialogButton.id = "closeDialogButton";
        closeDialogButton.title = "Close the dialog";
        closeDialogButton.innerHTML = " X ";
        dialogTitle.appendChild(titleText);
        dialogTitle.appendChild(closeDialogButton);
        dialog.appendChild(dialogTitle);
        var dialogBody = document.createElement("div");
        dialogBody.id = "dialogBody";
        dialogBody.innerHTML = content;
        dialog.appendChild(dialogBody);
        var dialogButton = document.createElement("div");
        dialogButton.id = "dialogConfirm";
        dialogButton.innerHTML = "OK";
        dialog.appendChild(dialogButton);
        dialogTitle.onmousedown = function (e) {
            document.getElementsByTagName("html")[0].style.cursor = "default";
            document.getElementsByTagName("body")[0].style.cursor = "default";
            dialog['offY'] = e.clientY - parseInt(dialog.offsetTop.toString());
            dialog['offX'] = e.clientX - parseInt(dialog.offsetLeft.toString());
            Dialog.addEventHandler(window, "mousemove", Dialog.move);
        };
        dialogTitle.onmouseup = function (e) {
            document.getElementsByTagName("html")[0].style.cursor = "";
            document.getElementsByTagName("body")[0].style.cursor = "";
            Dialog.removeEventHandler(window, "mousemove", Dialog.move);
        };
        var keyupHandler = function (e) {
        };
        closeDialogButton.onclick = function (e) {
            Dialog._close();
            Dialog.removeEventHandler(window, 'keyup', keyupHandler);
            if (typeof (close_callback) === "function")
                close_callback();
        };
        dialogButton.onclick = function (e) {
            closeDialogButton.onclick(e);
        };
        Dialog.addEventHandler(window, 'keyup', keyupHandler);
        document.body.appendChild(dialog);
    };
    Dialog.Confirm = function (content, confirm_callback, title, confirm_text, close_callback) {
        if (title === void 0) { title = ""; }
        if (confirm_text === void 0) { confirm_text = "OK"; }
        if (close_callback === void 0) { close_callback = function () { }; }
        Dialog.Close();
        var dialog = document.createElement("div");
        dialog.id = "dialog";
        var dialogTitle = document.createElement("div");
        dialogTitle.id = "dialogTitle";
        var titleText = document.createElement("span");
        titleText.id = "titleText";
        titleText.innerHTML = title;
        var closeDialogButton = document.createElement("div");
        closeDialogButton.id = "closeDialogButton";
        closeDialogButton.title = "Close the dialog";
        closeDialogButton.innerHTML = " X ";
        dialogTitle.appendChild(titleText);
        dialogTitle.appendChild(closeDialogButton);
        dialog.appendChild(dialogTitle);
        var dialogBody = document.createElement("div");
        dialogBody.id = "dialogBody";
        dialogBody.innerHTML = content;
        dialog.appendChild(dialogBody);
        var dialogButton = document.createElement("div");
        dialogButton.id = "dialogButton";
        dialogButton.innerHTML = "Cancel";
        dialog.appendChild(dialogButton);
        var dialogConfirm = document.createElement("div");
        dialogConfirm.id = "dialogConfirm";
        dialogConfirm.innerHTML = confirm_text;
        dialog.appendChild(dialogConfirm);
        dialogTitle.onmousedown = function (e) {
            document.getElementsByTagName("html")[0].style.cursor = "default";
            document.getElementsByTagName("body")[0].style.cursor = "default";
            dialog['offY'] = e.clientY - parseInt(dialog.offsetTop.toString());
            dialog['offX'] = e.clientX - parseInt(dialog.offsetLeft.toString());
            Dialog.addEventHandler(window, "mousemove", Dialog.move);
        };
        dialogTitle.onmouseup = function (e) {
            document.getElementsByTagName("html")[0].style.cursor = "";
            document.getElementsByTagName("body")[0].style.cursor = "";
            Dialog.removeEventHandler(window, "mousemove", Dialog.move);
        };
        var keyupHandler = function (e) {
        };
        closeDialogButton.onclick = function (e) {
            Dialog._close();
            Dialog.removeEventHandler(window, 'keyup', keyupHandler);
            if (typeof (close_callback) === "function")
                close_callback();
        };
        dialogButton.onclick = function (e) {
            closeDialogButton.onclick(e);
        };
        dialogConfirm.onclick = function (e) {
            if (typeof (confirm_callback) === "function")
                confirm_callback();
            closeDialogButton.onclick(e);
        };
        Dialog.addEventHandler(window, 'keyup', keyupHandler);
        document.body.appendChild(dialog);
    };
    Dialog.move = function (e) {
        var dialog = document.getElementById("dialog");
        dialog.style.position = "absolute";
        dialog.style.top = (e.clientY - dialog['offY']) + "px";
        dialog.style.left = (e.clientX - dialog['offX']) + 'px';
    };
    return Dialog;
}());
