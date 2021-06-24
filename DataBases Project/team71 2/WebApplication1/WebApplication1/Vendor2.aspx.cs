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
    public partial class Vendor2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {

            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();

            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);


            /*create a new SQL command which takes as parameters the name of the stored procedure and
             the SQLconnection name*/
            SqlCommand cmd = new SqlCommand("postProduct", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            string username = (string)(Session["Loggedinname"]);
            string productname = proname.Text;
            string cat = category.Text;
            string prodd = pd.Text;
            string price = p.Text;
            string color = c.Text;


            cmd.Parameters.Add(new SqlParameter("@vendorUsername", username));
            cmd.Parameters.Add(new SqlParameter("@product_name", productname));
            cmd.Parameters.Add(new SqlParameter("@category", cat));
            cmd.Parameters.Add(new SqlParameter("@product_description", prodd));
            cmd.Parameters.Add(new SqlParameter("@price", price));
            cmd.Parameters.Add(new SqlParameter("@color", color));




            try
            {
                //Executing the SQLCommand
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            catch (Exception ex)
            {
                Response.Write("Failed!");


            }



        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["M3"].ToString();

            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);


            /*create a new SQL command which takes as parameters the name of the stored procedure and
             the SQLconnection name*/
            SqlCommand cmd = new SqlCommand("vendorviewProducts", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            string username = (string)(Session["Loggedinname"]);
            cmd.Parameters.Add(new SqlParameter("@vendorUsername", username));

            try
            {
                //Executing the SQLCommand
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            catch (Exception ex)
            {
                Response.Write("Failed!");


            }
        }

        protected void Button3_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["M3"].ToString();

            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);


            /*create a new SQL command which takes as parameters the name of the stored procedure and
             the SQLconnection name*/
            SqlCommand cmd = new SqlCommand("EditProduct", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            string username1 = (string)(Session["Loggedinname"]);
            string productname1 = proname1.Text;
            string cat1 = category1.Text;
            string prodd1 = pd1.Text;
            string price1 = p1.Text;
            string color1 = c1.Text;
            string serialnum = sn.Text;

            cmd.Parameters.Add(new SqlParameter("@vendorUsername", username1));
            cmd.Parameters.Add(new SqlParameter("@product_name", productname1));
            cmd.Parameters.Add(new SqlParameter("@category", cat1));
            cmd.Parameters.Add(new SqlParameter("@product_description", prodd1));
            cmd.Parameters.Add(new SqlParameter("@price", price1));
            cmd.Parameters.Add(new SqlParameter("@color", color1));
            cmd.Parameters.Add(new SqlParameter("@@serialnumber", serialnum));





            //SqlParameter OrderID = cmd.Parameters.Add("@OrderID", SqlDbType.Int);
            //OrderID.Direction = ParameterDirection.Output;




            try
            {
                //Executing the SQLCommand
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            catch (Exception ex)
            {
                Response.Write("Failed!");


            }
        }

        protected void Button4_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["M3"].ToString();

            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);


            /*create a new SQL command which takes as parameters the name of the stored procedure and
             the SQLconnection name*/
            SqlCommand cmd = new SqlCommand("addoffer", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            string amo = amount.Text;
            string exp = date.Text;

            cmd.Parameters.Add(new SqlParameter("@offeramount", amo));
            cmd.Parameters.Add(new SqlParameter("@expiry_date", exp));
            try
            {
                //Executing the SQLCommand
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            catch (Exception ex)
            {
                Response.Write("Failed!");


            }



        }

        protected void Button5_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["M3"].ToString();

            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);


            /*create a new SQL command which takes as parameters the name of the stored procedure and
             the SQLconnection name*/
            SqlCommand cmd = new SqlCommand("checkofferonProduct", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            string username = (string)(Session["Loggedinname"]);

            string serialno = sn1.Text;
            string offer = offerid.Text;

            cmd.Parameters.Add(new SqlParameter("@serial", serialno));

            SqlParameter active = cmd.Parameters.Add("@activeoffer", SqlDbType.Int);
            active.Direction = ParameterDirection.Output;

            if (active.Equals('0'))
            {
                SqlCommand cmd2 = new SqlCommand("applyoffer", conn);
                cmd2.CommandType = CommandType.StoredProcedure;
                cmd2.Parameters.Add(new SqlParameter("@serial", serialno));
                cmd2.Parameters.Add(new SqlParameter("@vendorname", username));
                cmd2.Parameters.Add(new SqlParameter("@offerid", offer));
                cmd2.ExecuteNonQuery();
            }
            else
                Response.Write("There is an existing offer on the product");
            try
            {
                //Executing the SQLCommand
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            catch (Exception ex)
            {
                Response.Write("Failed!");

            }
        }

        protected void Button6_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["M3"].ToString();

            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);


            /*create a new SQL command which takes as parameters the name of the stored procedure and
             the SQLconnection name*/
            SqlCommand cmd = new SqlCommand("checkandremoveExpiredOffer", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            string id = Offeridd.Text;
            cmd.Parameters.Add(new SqlParameter("@offerid", id));

            try
            {
                //Executing the SQLCommand
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            catch (Exception ex)
            {
                Response.Write("Failed!");

            }

        }
    }
}

 