using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace COE184P_Project
{
    /// <summary>
    /// Summary description for Planner
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class Planner : System.Web.Services.WebService
    {
        [WebMethod]
        public int AddNewEvent(int UserID, string RepetitionType, string EventTitle, string EventDesc, string EventDate, string EventStart, string EventEnd)
        {
            int retRecord = 0;
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.AddNewEvent", con))
                {
                    DateTime EDate = Convert.ToDateTime(EventDate);
                    DateTime EStart = Convert.ToDateTime(EventStart);
                    DateTime EEnd = Convert.ToDateTime(EventEnd);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserID_FK", UserID);//("FirstName", SqlDbType.VarChar, 100).Value = Fname;
                    cmd.Parameters.AddWithValue("@RepetitionType", RepetitionType);//("LastName", SqlDbType.VarChar, 100).Value = Lname;
                    cmd.Parameters.AddWithValue("@EventTitle", EventTitle);//("Password", SqlDbType.VarChar, 200).Value = Password;
                    cmd.Parameters.AddWithValue("@EventDescription", EventDesc);//("Email", SqlDbType.VarChar, 200).Value = Email;
                    cmd.Parameters.AddWithValue("@EventDate", EDate);//("Birthday", SqlDbType.Date).Value = Bday;
                    cmd.Parameters.AddWithValue("@EventStartTime", EStart);
                    cmd.Parameters.AddWithValue("@EventEndTime", EEnd);
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    retRecord = cmd.ExecuteNonQuery();
                }

            }
            return retRecord;
        }   
       
        [WebMethod]
        public string Login(string Email, string Password)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {

                using (SqlCommand cmd = new SqlCommand("dbo.ValidateLogin", con))
                {

                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Email", Email);
                    cmd.Parameters.AddWithValue("@Password", Password);
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    cmd.ExecuteNonQuery();
                    if (cmd.Parameters.Contains("UT.UserID"))
                    {
                        return "Valid Entry";
                    }
                    else
                    {
                        return "Invalid Entry";
                    }

                }
            }
        } 

        [WebMethod]
        public int Register(string FirstName, string LastName, string Gender, string Email, string Password, string Birthday)
        {
            int retRecord=0;
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.AddNewUser", con))
                {
                    int GndrID=0;
                    if (Gender == "Male")
                    {
                        GndrID = 1;
                    }
                    else if(Gender == "Female")
                    {
                        GndrID = 2;
                    }
                    DateTime Bday = Convert.ToDateTime(Birthday);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@FirstName", FirstName);//("FirstName", SqlDbType.VarChar, 100).Value = Fname;
                    cmd.Parameters.AddWithValue("@LastName", LastName);//("LastName", SqlDbType.VarChar, 100).Value = Lname;
                    cmd.Parameters.AddWithValue("@Password", Password);//("Password", SqlDbType.VarChar, 200).Value = Password;
                    cmd.Parameters.AddWithValue("@Email", Email);//("Email", SqlDbType.VarChar, 200).Value = Email;
                    cmd.Parameters.AddWithValue("@Birthday", Bday);//("Birthday", SqlDbType.Date).Value = Bday;
                    cmd.Parameters.AddWithValue("@GenderID_FK", GndrID);
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    retRecord = cmd.ExecuteNonQuery();
                }

            }
            return retRecord;
        }

        [WebMethod]
        public DataSet GetProfileByID(int UserID)
        {
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.GetUserInfo", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserID", UserID);
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    SqlDataAdapter adp = new SqlDataAdapter();
                    adp.SelectCommand = cmd;
                    adp.Fill(ds);
                    if (con.State == ConnectionState.Open)
                    {
                        con.Close();
                    }
                }
            }
            return ds;
        }



        /*
        [WebMethod]
        public DataSet Login(string Email, string Password)
        {
            SqlDataAdapter da = new SqlDataAdapter("select * from login where user_name ='" + Email + "' and password='" + Password + "' ",
            @"DataSource=SERVER_NAME;Initial Catalog=EMP;Integrated Security=True");

            DataSet ds = new DataSet();
            da.Fill(ds);
            return ds;

        }
        
        [WebMethod]
        public DataSet Register(string FirstName, string LastName, string Email, string Password, string Gender, string Birthday)
        {
            SqlDataAdapter da = new SqlDataAdapter("Add * from Register where FName ='" + FirstName + "' AND LName ='" + LastName + "' AND Email ='" + Email +
                "'AND Password ='" + Password + "' AND Gender = '" + Gender + "' and Birthday = '" + Birthday + "'", @"DataSource=SERVER_NAME;Initial Catalog=EMP;Integrated Security=True");
            DataSet ds = new DataSet();
            da.Fill(ds);
            return ds;

        }
        */

    }
}
