    <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebApplication1.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="usernamehead" runat="server" Text="username"></asp:Label>
            <asp:TextBox ID="TextBoxusername" runat="server"></asp:TextBox>

        </div>
        <p>
            <asp:Label ID="passwordhead" runat="server" Text="passowrd"></asp:Label>
            <asp:TextBox ID="TextBoxpassword" runat="server"></asp:TextBox>
            </p>
        <p>
            <asp:Button ID="Buttonlogin" runat="server" Text="login" OnClick="Buttonlogin_Click" />
            </p>
        <p>
            <asp:Button ID="Button1" runat="server" Text="I DONT HAVE AN ACCOUNT" OnClick="redirectRegister_Click" /> 

        </p>
  
    </form>
</body>
</html>
