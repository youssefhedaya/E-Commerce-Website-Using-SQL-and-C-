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
    public partial class orderView : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Label lbl_ordernum = new Label();

            string ordernumber = Session["OrderID"].ToString();
            string totalamount = Session["totalamount"].ToString();


            lbl_ordernum.Text = "Order Number is " + ordernumber + "<br />  Total Amount: " + totalamount + " LE";

            form1.Controls.Add(lbl_ordernum);



        }

        protected void cashButton_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            SqlCommand cmd = new SqlCommand("specifyAmount", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            string cashaomunt = cashText.Text;
            string username = Session["username"].ToString();
            int Ordernumber = Convert.ToInt32(Session["OrderID"].ToString());
            int credit = 0;

            cmd.Parameters.Add(new SqlParameter("@customername", username));
            cmd.Parameters.Add(new SqlParameter("@orderID", Ordernumber));
            cmd.Parameters.Add(new SqlParameter("@cash", cashaomunt));
            cmd.Parameters.Add(new SqlParameter("@credit", credit));

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
        }

        protected void creditButton_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();
            SqlConnection conn = new SqlConnection(connStr);
            //userLogin
            SqlCommand cmd = new SqlCommand("specifyAmount", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            string creditamount = creditText.Text;
            string username = Session["username"].ToString();
            int Ordernumber = Convert.ToInt32(Session["OrderID"].ToString());
            int cash = 0;

            cmd.Parameters.Add(new SqlParameter("@customername", username));
            cmd.Parameters.Add(new SqlParameter("@orderID", Ordernumber));
            cmd.Parameters.Add(new SqlParameter("@cash", cash));
            cmd.Parameters.Add(new SqlParameter("@credit", creditamount));

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();

            Response.Redirect("creditcardView.aspx", true);


        }

        protected void Button1_Click(object sender, EventArgs e)
        {

        }

        protected void cancelButt_Click(object sender, EventArgs e)
        {

            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand cmd = new SqlCommand("cancelOrder", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlParameter canbecancelled1 = cmd.Parameters.Add("@canbecancelled", SqlDbType.Int);
            canbecancelled1.Direction = ParameterDirection.Output;


            int Ordernumber = Convert.ToInt32(Session["OrderID"].ToString());
            cmd.Parameters.Add(new SqlParameter("@orderid", Ordernumber));


            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
            string canbecancelled = canbecancelled1.Value.ToString();

            if(canbecancelled == "0")
                Response.Write("Ship has sailed, cannot cancel order");

        }

       //protected void creditcardButton_Click(object sender, EventArgs e)
       // {
        //    string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();
        //    SqlConnection conn = new SqlConnection(connStr);

        //    SqlCommand cmd = new SqlCommand("chooseCreditCard", conn);
        //    cmd.CommandType = CommandType.StoredProcedure;

         //   int Ordernumber = Convert.ToInt32(Session["OrderID"].ToString());
            //string cc = creditcardText.Text;
         //   cmd.Parameters.Add(new SqlParameter("@orderID", Ordernumber));
         //////   cmd.Parameters.Add(new SqlParameter("@creditcard", cc));


           //// conn.Open();
            //cmd.ExecuteNonQuery();
            //conn.Close();
            //Response.Redirect("creditcardView.aspx", true);


       // }
    }
}