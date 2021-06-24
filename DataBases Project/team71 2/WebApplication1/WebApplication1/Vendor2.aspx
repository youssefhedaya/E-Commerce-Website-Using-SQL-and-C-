<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Vendor2.aspx.cs" Inherits="WebApplication1.Vendor2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="Label1" runat="server" Text="Enter Product name: "></asp:Label>
            <asp:TextBox ID="proname" runat="server"></asp:TextBox>
                        <br \>
            <asp:Label ID="Label2" runat="server" Text="Category"></asp:Label>
            <asp:TextBox ID="category" runat="server"></asp:TextBox>
            <br \>
            <asp:Label ID="Label3" runat="server" Text="Product Description"></asp:Label>
            <asp:TextBox ID="pd" runat="server"></asp:TextBox>
            <br \>
            <asp:Label ID="Label4" runat="server" Text="Price"></asp:Label>
            <asp:TextBox ID="p" runat="server"></asp:TextBox>
            <br \>
            <asp:Label ID="Label5" runat="server" Text="Color"></asp:Label>
            <asp:TextBox ID="c" runat="server"></asp:TextBox>
            <br \>
             <br \>
            <asp:Button ID="Button1" runat="server" Text="Post my products" OnClick="Button1_Click" />
                        <br \>
             <br \>
            <asp:Label ID="Label20" runat="server" Text="To view my product please click below: "></asp:Label>
                         <br\>

            <asp:Button ID="Button2" runat="server" Text="View my products" OnClick="Button2_Click" />
             <br \>
                         <br \>

            <asp:Label ID="Label6" runat="server" Text="Edit Product name: "></asp:Label>
            <asp:TextBox ID="proname1" runat="server"></asp:TextBox>
                        <br \>
            <asp:Label ID="Label7" runat="server" Text="Edit Category"></asp:Label>
            <asp:TextBox ID="category1" runat="server"></asp:TextBox>
            <br \>
            <asp:Label ID="Label8" runat="server" Text="Edit Product Description"></asp:Label>
            <asp:TextBox ID="pd1" runat="server"></asp:TextBox>
            <br \>
            <asp:Label ID="Label9" runat="server" Text="Edit Price"></asp:Label>
            <asp:TextBox ID="p1" runat="server"></asp:TextBox>
            <br \>
            <asp:Label ID="Label10" runat="server" Text="Edit Color"></asp:Label>
            <asp:TextBox ID="c1" runat="server"></asp:TextBox>
            <br \>
            <asp:Label ID="Label11" runat="server" Text="Edit Serial Number"></asp:Label>   
            <asp:TextBox ID="sn" runat="server"></asp:TextBox>
             <br \>
             <br \>
            <asp:Button ID="Button3" runat="server" Text="Edit my products" OnClick="Button3_Click" />
             <br \>
                         <br \>

            <asp:Label ID="Label14" runat="server" Text="To Create an offer please fill in below:"></asp:Label>
                         <br \>
             <asp:Label ID="Label12" runat="server" Text="Add offer amount: "></asp:Label>
            <asp:TextBox ID="amount" runat="server"></asp:TextBox>
            <br \>
            <asp:Label ID="Label13" runat="server" Text="Expiry date: "></asp:Label>   
            <asp:TextBox ID="date" runat="server"></asp:TextBox>
                         <br \>
            <asp:Button ID="Button4" runat="server" Text="CREATE" OnClick="Button4_Click" />
                                     <br \>
                                     <br \>

            <asp:Label ID="Label15" runat="server" Text="To add offer on product please fill in below: "></asp:Label>
                                     <br \>
            <asp:Label ID="Label16" runat="server" Text="Product serialnumber: "></asp:Label>
            <asp:TextBox ID="sn1" runat="server"></asp:TextBox>
                                     <br \>
            <asp:Label ID="Label17" runat="server" Text="OfferID"></asp:Label>
            <asp:TextBox ID="offerid" runat="server"></asp:TextBox>
                                     <br \>
            <asp:Button ID="Button5" runat="server" Text="APPLY" OnClick="Button5_Click" />
                                                 <br \>
                                     <br \>
            <asp:Label ID="Label18" runat="server" Text="If you want to remove any expired offer please click below: "></asp:Label>
                                                 <br \>
            <asp:Label ID="Label19" runat="server" Text="Enter offerID:"></asp:Label>
            <asp:TextBox ID="Offeridd" runat="server"></asp:TextBox>   
                                                 <br \>

          <asp:Button ID="Button6" runat="server" Text="REMOVE" OnClick="Button6_Click" style="height: 26px" />
        </div>
    </form>
</body>
</html>

