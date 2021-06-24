<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="addCCView.aspx.cs" Inherits="WebApplication1.addCCView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="Label1" runat="server" Text="CREDITCARD NUMBER"></asp:Label>





        </div>
        <p>
            <asp:TextBox ID="TextBoxNumber" runat="server"></asp:TextBox>

            </p>
        <p>

            <asp:Label ID="Label2" runat="server" Text="Expiry Date"></asp:Label>
            </p>
        <p>
            <asp:TextBox ID="TextBoxexpiry" runat="server"></asp:TextBox>

             </p>
        <p>

             <asp:Label ID="Label3" runat="server" Text="CVV"></asp:Label>
            </p>
        <p>
            <asp:TextBox ID="TextBoxCVV" runat="server" OnTextChanged="TextBoxCVV_TextChanged"></asp:TextBox>



        </p>
        <p>


            <asp:Button ID="ButtonADD" runat="server" Text="Add Creditcard" OnClick="ButtonADD_Click" />



        </p>
    </form>
</body>
</html>
