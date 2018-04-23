<%@ Page Language="vb" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="LinkedControls" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>Client Callback With Accessible Notification</title>
    <link rel="stylesheet" type="text/css" href="css/demos.css" />
    <link href='https://fonts.googleapis.com/css?family=Open+Sans:300,600,400' rel='stylesheet' type='text/css' />
    <link href="css/dx.common.css" rel="stylesheet" type="text/css" />
    <link href="css/dx.light.css" rel="stylesheet" type="text/css" />
    <script src="scripts/jquery/jquery-2.2.3.min.js"></script>
    <script src="scripts/dx.web.js"></script>
    <script src="scripts/db.js"></script>

    <script src="scripts/AccessibilityHelper.js"></script>
    <script>
        $(function () {
            var accessibilityHelper = new AccessibilityHelper();

            var oldGridTotalCount = clients.length;
            var listBoxChanged = false;
            var listBox = $("#lbCountries");
            var grid = $("#dxGrid").dxDataGrid({ //dxDataGrid - https://js.devexpress.com/Documentation/16_1/ApiReference/UI_Widgets/dxDataGrid/
                dataSource: clients,
                paging: { enabled: "true", pageSize: 15 },
                onContentReady: OnContentReady,
                columns: ["Name", "Address",
                    {
                        dataField: "Age",
                        dataType: "number"
                    },
                    {
                        dataField: "Country",
                        dataType: "number",
                        lookup: {
                            dataSource: countries,
                            displayExpr: "Name",
                            valueExpr: "Id"
                        }
                    }]
            }).dxDataGrid("instance");

            listBox.init(
                function () {
                    for (var i = 0; i < countries.length; i++) {
                        listBox.append($('<option>',
                            {
                                value: countries[i].Id,
                                text: countries[i].Name
                            }));
                    }
                }).change(
                function () {
                    var filterOptions = listBox.val();
                    oldGridTotalCount = grid.totalCount();
                    listBoxChanged = true;
                    grid.filter(BuildFilterExpression(filterOptions));
                });

            function OnContentReady() {
                if (!listBoxChanged)
                    return;
                listBoxChanged = false;
                var newCount = grid.totalCount();
                var changesInfo = GetChangesInfo(newCount);
                accessibilityHelper.SendMessageToAssistiveTechnology(changesInfo);
            }
            function GetChangesInfo(newCount) {
                var message = "Accepted clients grid updated.";
                if (oldGridTotalCount != newCount) {
                    message += " Elements count changed from " + oldGridTotalCount + ' to ' + newCount + '. ';
                }
                return message;
            }
            function BuildFilterExpression(filterOptions) {
                if (!filterOptions)
                    return null;
                var filterExpr = [];
                var colName = "Country";
                for (var i = 0; i < filterOptions.length; i++) {
                    filterExpr.push([colName, "=", filterOptions[i]]);
                    filterExpr.push("or");
                }
                return filterExpr;
            }
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <h1>Client Callback With Accessible Notification </h1>
        <table>
            <tr>
                <td style="vertical-align: top; padding-right: 20px;">
                    <div>
                        <asp:Label runat="server" ID="lblCountries" AssociatedControlID="lbCountries" Text="Countries:">
                        </asp:Label>
                        <br />
                        <asp:ListBox ID="lbCountries" runat="server" SelectionMode="Multiple"
                            Height="150px"></asp:ListBox>
                    </div>
                </td>
                <td style="">
                    <span>Clients:</span>
                    <div tabindex="0" id="dxGrid"></div>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>