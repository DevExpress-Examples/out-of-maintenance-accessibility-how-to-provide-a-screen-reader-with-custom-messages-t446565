# Accessibility: How to provide a screen reader with custom messages


<p>This example illustrates how to provide a custom message to an Assistive Technology (for example, Screen Reader). The main idea of this approach is to add a special helper element to the page, set your custom message as its "aria-label" attribute value, and then focus this element. This will force your screen reader or another assistive technology to read the message.</p>
<p><br>Here, the task is implemented for a basic ASP.NET ListBox and DevExtreme <a href="https://js.devexpress.com/Documentation/16_1/ApiReference/UI_Widgets/dxDataGrid/">dxDataGrid </a>widget. The grid displays data depending on the ListBox selection. When the selection is changed, the data in the linked grid is filtered  and we send a custom information message. A similar scenario is illustrated in the <a href="http://demos.devexpress.com/ASPxEditorsDemos/Accessibility/LinkedControls.aspx">Accessibility - Linked Controls</a> online demo, but instead of a custom <strong>AccessibilityHelper</strong> implementation, this demo uses our client API: <a href="http://help.devexpress.com/#AspNet/DevExpressWebScriptsASPxClientControlBase_SendMessageToAssistiveTechnologytopic">ASPxClientUtils.SendMessageToAssistiveTechnology</a>.<br><br><strong>Main implementation steps:</strong><br>1. Add a special assistive element to the page using the <strong>AccessibilityHelper</strong> constructor (its implementation is in the<em> AccessibilityHelper.js</em> file):</p>


```js
var accessibilityHelper = new AccessibilityHelper();

```


<p> 2. Save the old state for a control or page, when necessary. In this example, the ListBox' <em>onchange</em> event is used for this purpose:</p>


```js
 listBox.change(function () {
      ...
      oldClientCount = grid.totalCount();
      countriesChanged = true;
      ...
});

```


<p> You can handle several events for different controls in your real-life scenario.</p>
<p>3. Handle the event that occurs when changes are complete. Here, the <a href="https://js.devexpress.com/Documentation/16_1/ApiReference/UI_Widgets/dxDataGrid/Configuration/#onContentReady">dxDataGrid.onContentReady</a> event is used. Check if there is the difference between the previous and current states, and to pass the corresponding message text as an argument to the <strong>AccessibilityHelper.SendMessageToAssistiveTechnology</strong> method:</p>


```js
function OnContentReady() {
       ...
       var newCount = grid.totalCount();
       var changesInfo = GetChangesInfo(newCount);
       accessibilityHelper.SendMessageToAssistiveTechnology(changesInfo);
 }

```


<p> The complete implementation of the <strong>AccessibilityHelper.SendMessageToAssistiveTechnology</strong> method is in the <em>AccessibilityHelper.js</em> file.</p>
<p><br>To test the example, run it in browser and enable your assistive technology. You can use <a href="http://webaim.org/articles/nvda/">NVDA </a>or <a href="http://webaim.org/articles/jaws/">JAWS </a>screen readers for testing purposes. Change the "Countries" list box selection: the assistive software or device should inform you about the changes in the "Clients" grid with a corresponding message.<br><br><strong>See Also:</strong><br><a href="https://documentation.devexpress.com/#AspNet/CustomDocument117274">Accessibility - How To: Provide a Screen Reader with Information About Changes on a Page</a></p>

<br/>


