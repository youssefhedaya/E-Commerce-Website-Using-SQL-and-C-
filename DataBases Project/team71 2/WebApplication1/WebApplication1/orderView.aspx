<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="orderView.aspx.cs" Inherits="WebApplication1.orderView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="credit" runat="server" Text="Credit Amount"></asp:Label>
            <asp:TextBox ID="creditText" runat="server"></asp:TextBox>
            <asp:Button ID="creditButton" runat="server" Text="Pay in Credit" OnClick="creditButton_Click" />

        </div>
        <p>
            <asp:Label ID="cash" runat="server" Text="Cash Amount"></asp:Label>
            <asp:TextBox ID="cashText" runat="server"></asp:TextBox>
            <asp:Button ID="cashButton" runat="server" Text="Pay in Cash" OnClick="cashButton_Click" />
        </p>
        <p>
            <asp:Button ID="cancelButt" runat="server" Text="Cancel Order" OnClick="cancelButt_Click" />
        </p>
        <p>
            &nbsp;</p>
        <p>
            &nbsp;</p>
        <p>
            &nbsp;</p>
    </form>
</body>
</html>
