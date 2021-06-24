<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="creditcardView.aspx.cs" Inherits="WebApplication1.creditcardView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="Label1" runat="server" Text="Choose credit card"></asp:Label>
        </div>
        <p>
            <asp:Label ID="Label2" runat="server" Text="credit card number"></asp:Label> 
            <asp:TextBox ID="ccnumber" runat="server"></asp:TextBox>


        </p>
        <p>
            <asp:Button ID="creditcard" runat="server" Text="Choose" OnClick="creditcard_Click" />


        </p>
    </form>
</body>
</html>
