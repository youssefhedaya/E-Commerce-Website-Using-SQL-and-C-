using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class customerView : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand cmd = new SqlCommand("ShowProductsbyPrice", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            conn.Open();
            SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
            while (rdr.Read())
            {
                string prodName = rdr.GetString(rdr.GetOrdinal("product_name"));
                Decimal  prodPriceDec = rdr.GetDecimal(rdr.GetOrdinal("price"));
                string prodPrice = prodPriceDec.ToString();
                Label lbl_prodName = new Label();
               
                lbl_prodName.Text = "  <br /> <br />" + prodName + "<br /> " + prodPrice + " LE";
                form1.Controls.Add(lbl_prodName );


                //Button butt_prodName = new Button();
                //butt_prodName.Text = "BUY " + prodName;
                //form1.Controls.Add(butt_prodName);
               // butt_prodName.OnClientClick = "Response.Write('yeah')";  



            }
        }

        protected void ButtonCreateWishlist_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            
            SqlCommand cmd = new SqlCommand("createWishlist", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            string wishlistname = TextBoxCreateWishlist.Text;
            string username = Session["username"].ToString();
            Response.Write(username);

            cmd.Parameters.Add(new SqlParameter("@customername", username));
            cmd.Parameters.Add(new SqlParameter("@name", wishlistname));

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();

        }

        protected void ButtonAddCreditcard_Click(object sender, EventArgs e)
        {
            Response.Redirect("addCCView.aspx", true);
        }

        protected void makeorder_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand cmd = new SqlCommand("makeOrder", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            string username = Session["username"].ToString();
            SqlParameter emptycart1 = cmd.Parameters.Add("@cartempty", SqlDbType.Int);
            emptycart1.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(new SqlParameter("@customername", username));

            SqlParameter ordernumber1 = cmd.Parameters.Add("@ordernum", SqlDbType.Int);
            ordernumber1.Direction = ParameterDirection.Output;

            SqlParameter totalamount1 = cmd.Parameters.Add("@sum", SqlDbType.Decimal);
            totalamount1.Direction = ParameterDirection.Output;
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
            string emptycart = emptycart1.Value.ToString();

            if (emptycart == "0")
                Response.Write("Your cart is empty");
            else
            {
                String totalamount = totalamount1.Value.ToString();
                String ordernumber = ordernumber1.Value.ToString();
                Session["OrderID"] = ordernumber;
                Session["totalamount"] = totalamount;
                Response.Redirect("orderView.aspx", true);
            }
            


            //Response.Write(totalamount1);
            

           

            

            


        }

        protected void ButtonWishlist_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand cmd = new SqlCommand("AddtoWishlist", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            string wishlistname = TextBoxWishlistname.Text;
            string username = Session["username"].ToString();
            string serial_no = TextBoxWishlist.Text;

            cmd.Parameters.Add(new SqlParameter("@customername", username));
            cmd.Parameters.Add(new SqlParameter("@name", wishlistname));
            cmd.Parameters.Add(new SqlParameter("@serial", serial_no));

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();


        }

        protected void ButtonCart_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand cmd = new SqlCommand("addToCart", conn);
            cmd.CommandType = CommandType.StoredProcedure;


            string username = Session["username"].ToString();
            int serial_no = Convert.ToInt32(TextBoxCart.Text);


            cmd.Parameters.Add(new SqlParameter("@customername", username));
            cmd.Parameters.Add(new SqlParameter("@serial", serial_no));

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand cmd = new SqlCommand("removefromWishlist", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            string wishlistname = TextBoxWishlistname.Text;
            string username = Session["username"].ToString();
            string serial_no = TextBoxWishlist.Text;

            cmd.Parameters.Add(new SqlParameter("@customername", username));
            cmd.Parameters.Add(new SqlParameter("@name", wishlistname));
            cmd.Parameters.Add(new SqlParameter("@wish_name", serial_no));

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();

        }

        protected void ButtonRemoveCart_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand cmd = new SqlCommand("removefromCart", conn);
            cmd.CommandType = CommandType.StoredProcedure;


            string username = Session["username"].ToString();
            string serial_no = TextBoxCart.Text;


            cmd.Parameters.Add(new SqlParameter("@customername", username));
            cmd.Parameters.Add(new SqlParameter("@serial", serial_no));
        }

        protected void addphonenumber_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand cmd = new SqlCommand("addMobile", conn);
            cmd.CommandType = CommandType.StoredProcedure;


            string username = Session["username"].ToString();
            string number = phonenumber.Text;
            cmd.Parameters.Add(new SqlParameter("@username", username));
            cmd.Parameters.Add(new SqlParameter("@mobile_number", number));
            try
            {


                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            catch(Exception ee)
            {
                Response.Write("This number already exists");
            }
        }
    }
}