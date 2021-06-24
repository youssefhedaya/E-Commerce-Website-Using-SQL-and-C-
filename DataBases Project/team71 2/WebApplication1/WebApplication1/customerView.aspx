<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="customerView.aspx.cs" Inherits="WebApplication1.customerView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="Label1" runat="server" Text="Create Wishlist"></asp:Label>
        </div>
        <p>
            <asp:TextBox ID="TextBoxCreateWishlist" runat="server"></asp:TextBox>
            </p>
        <p>
            <asp:Button ID="ButtonCreateWishlist" runat="server" Text="Create Wishlist" OnClick="ButtonCreateWishlist_Click" />
            
            </p>
        <p>
            <asp:Label ID="Label2" runat="server" Text="Add phone number"></asp:Label>
            
            <asp:TextBox ID="phonenumber" runat="server"></asp:TextBox>
            <asp:Button ID="addphonenumber" runat="server" Text="Add phone number" OnClick="addphonenumber_Click" />
            </p>
        <p>

            
            <asp:Button ID="ButtonAddCreditcard" runat="server" Text="Add Credit Card" OnClick="ButtonAddCreditcard_Click" Width="574px" />
        </p>
        <asp:Button ID="makeorder" runat="server" Text="Make Order" OnClick="makeorder_Click" />

        <br />
        <br />
        <br />
        Add Serial Number of Product you want to add to Wishlist<p>
            <asp:TextBox ID="TextBoxWishlist" runat="server"></asp:TextBox>
            <asp:Button ID="ButtonWishlist" runat="server" Text="Add To Wishlist" Width="152px" OnClick="ButtonWishlist_Click" />

            <asp:Button ID="ButtonRemoveWishlist" runat="server" OnClick="Button1_Click" Text="Remove From Wishlist" />
        </p>
        <p>

            Name of Your Wishlist to Add/Remove To
            <asp:TextBox ID="TextBoxWishlistname" runat="server" ></asp:TextBox>
        </p>
        <p>
            Add Serial Number of Product you want to add to cart</p>

        <p>

            <asp:TextBox ID="TextBoxCart" runat="server" Width="255px"></asp:TextBox>
            <asp:Button ID="ButtonCart" runat="server" Text="Add To Cart" OnClick="ButtonCart_Click" />
            <asp:Button ID="ButtonRemoveCart" runat="server" Text="Remove From Cart" OnClick="ButtonRemoveCart_Click" />
        </p>

    </form>
</body>
</html>
