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
    public partial class customerRegister : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void customerRegister_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand cmd = new SqlCommand("customerRegister", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            string username = TextBox_username.Text;
            string first_name = TextBox_firstname.Text;
            string last_name = TextBox_lastname.Text;
            string password = TextBox_password.Text;
            string email = TextBox_email.Text;

            cmd.Parameters.Add(new SqlParameter("@username", username));
            cmd.Parameters.Add(new SqlParameter("@first_name", first_name));
            cmd.Parameters.Add(new SqlParameter("@last_name", last_name));
            cmd.Parameters.Add(new SqlParameter("@password", password));
            cmd.Parameters.Add(new SqlParameter("@email", email));
            SqlParameter userexists1 = cmd.Parameters.Add("@exists", SqlDbType.Int);
            userexists1.Direction = ParameterDirection.Output;

            if (username is null)
            {
                Response.Write("USERNAME IS EMPTY");
            }
            else
            {

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
                string userexists = userexists1.Value.ToString();
                if (userexists == "1")
                    Response.Write("Username already exists");
                else
                    Response.Write("Registration Successful");
            }

        }

        protected void TextBox_companyname_TextChanged(object sender, EventArgs e)
        {

        }

        protected void vendorRegister_Click(object sender, EventArgs e)
        {

            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ToString();
            SqlConnection conn = new SqlConnection(connStr);

            SqlCommand cmd = new SqlCommand("vendorRegister", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            string username = TextBox_username.Text;
            string first_name = TextBox_firstname.Text;
            string last_name = TextBox_lastname.Text;
            string password = TextBox_password.Text;
            string email = TextBox_email.Text;
            string company_name = TextBox_companyname.Text;
            string bank_acc_no = TextBox_bankaccount.Text;


            cmd.Parameters.Add(new SqlParameter("@username", username));
            cmd.Parameters.Add(new SqlParameter("@first_name", first_name));
            cmd.Parameters.Add(new SqlParameter("@last_name", last_name));
            cmd.Parameters.Add(new SqlParameter("@password", password));
            cmd.Parameters.Add(new SqlParameter("@email", email));
            cmd.Parameters.Add(new SqlParameter("@company_name", company_name));
            cmd.Parameters.Add(new SqlParameter("@bank_acc_no", bank_acc_no));

            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();

        }
    }
}