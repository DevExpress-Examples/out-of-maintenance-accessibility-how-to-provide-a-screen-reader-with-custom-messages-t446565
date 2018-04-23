var AccessibilityHelper = (function () {
    var assistiveElement = null;
    var pronounceTimeout = 200;

    function AccessibilityHelper() {
        if (!assistiveElement)
            createAssistiveElement();
    }
    AccessibilityHelper.prototype.SendMessageToAssistiveTechnology = function (message) {
        var focusedElement = document.activeElement;

        setAttribute(assistiveElement, 'tabindex', 0);
        setAttribute(assistiveElement, 'aria-label', message);
        assistiveElement.focus();

        setTimeout(function () {
            focusedElement.focus();
            removeAttribute(assistiveElement, 'tabindex');
        }, pronounceTimeout);

    }

    function createAssistiveElement() {
        assistiveElement = document.createElement('DIV');

        setAttribute(assistiveElement, 'id', 'accessible_assist');
        setAttribute(assistiveElement, 'role', 'application');
        setAttribute(assistiveElement, 'style', 'position:fixed;left:0px;top:0px;clip: rect(1px, 1px, 1px, 1px);-webkit-clip-path: polygon(0 0);');

        assistiveElement.innerHTML = '&nbsp;';
        document.body.insertBefore(assistiveElement, document.body.childNodes[0]);
    }

    function setAttribute(obj, attrName, value) {
        if (obj.setAttribute)
            obj.setAttribute(attrName, value);
        else if (obj.setProperty)
            obj.setProperty(attrName, value, "");
    }

    function removeAttribute(obj, attrName) {
        if (obj.removeAttribute)
            obj.removeAttribute(attrName);
        else if (obj.removeProperty)
            obj.removeProperty(attrName);
    }
    return AccessibilityHelper;
})();

