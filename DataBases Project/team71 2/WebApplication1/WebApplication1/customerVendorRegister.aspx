<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="customerVendorRegister.aspx.cs" Inherits="WebApplication1.customerRegister" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="Label1" runat="server" Text="Username"></asp:Label>
            <asp:TextBox ID="TextBox_username" runat="server"></asp:TextBox>

        </div>
        <p>

            <asp:Label ID="Label2" runat="server" Text="First Name"></asp:Label>
            <asp:TextBox ID="TextBox_firstname" runat="server"></asp:TextBox>

            <asp:Label ID="Label3" runat="server" Text="Last Name"></asp:Label>
            <asp:TextBox ID="TextBox_lastname" runat="server" Width="188px"></asp:TextBox>
            
            </p>
        <p>
            
            <asp:Label ID="Label4" runat="server" Text="Password"></asp:Label>
            </p>
        <p>
            <asp:TextBox ID="TextBox_password" runat="server"></asp:TextBox>
            
            </p>
        <p>
            
            <asp:Label ID="Label5" runat="server" Text="Email"></asp:Label>
            </p>
        <p>
            <asp:TextBox ID="TextBox_email" runat="server"></asp:TextBox>

            </p>
        <p>
            &nbsp;</p>
        <p>


            <asp:Label ID="Label7" runat="server" Text="Bank Account"></asp:Label>
              (if Vendor)</p>
        <p>
              <asp:TextBox ID="TextBox_bankaccount" runat="server"></asp:TextBox>

            </p>
        <p>

            <asp:Label ID="Label6" runat="server" Text="Company Name"></asp:Label>
            (if Vendor)</p>
        <p>
            <asp:TextBox ID="TextBox_companyname" runat="server" OnTextChanged="TextBox_companyname_TextChanged"></asp:TextBox>


            </p>
        <p>

            <asp:Button ID="Button2" runat="server" Text="Register as an Vendor" OnClick="vendorRegister_Click" />

            <asp:Button ID="Button1" runat="server" Text="Register as a Customer" OnClick ="customerRegister_Click" />

            </p>
        <p>
            &nbsp;</p>
    </form>
</body>
</html>
