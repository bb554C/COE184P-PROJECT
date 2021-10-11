using System;
using System.Collections.Generic;
using COE184P_Project;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using Newtonsoft.Json;

namespace COE184P_Project
{
    /// <summary>
    /// Summary description for Planner
    /// </summary>
    [WebService(Namespace = "http://192.168.1.3/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [ScriptService]
    public class Planner : WebService
    {
        public void connectionClose(SqlConnection con)
        {
            if (con.State == ConnectionState.Open)
            {
                con.Close();
            }
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = true)]
        public string HelloWorld()
        {
            return "HELLO WORLD";
        }

        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public string AddNewEvent(int UserID, string PriorityType, string EventTitle, string EventDesc, string EventDate, string EventStart, string EventEnd)
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
                    cmd.Parameters.AddWithValue("@PriorityType", PriorityType);//("LastName", SqlDbType.VarChar, 100).Value = Lname;
                    cmd.Parameters.AddWithValue("@EventTitle", EventTitle);//("Password", SqlDbType.VarChar, 200).Value = Password;
                    cmd.Parameters.AddWithValue("@EventDescription", EventDesc);//("Email", SqlDbType.VarChar, 200).Value = Email;
                    cmd.Parameters.AddWithValue("@EventDate", EDate);//("Birthday", SqlDbType.Date).Value = Bday;
                    cmd.Parameters.AddWithValue("@EventStartTime", EStart);
                    cmd.Parameters.AddWithValue("@EventEndTime", EEnd);
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    retRecord = 1;
                    cmd.ExecuteNonQuery();
                }
                connectionClose(con);
            }
            return new JavaScriptSerializer().Serialize(retRecord);
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public string Login(string Email, string Password)
        {
            string ID = "INVALID";
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                var dataset = new DataSet();
                using (SqlCommand cmd = new SqlCommand("dbo.ValidateLogin", con))
                {

                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Email", Email);
                    cmd.Parameters.AddWithValue("@Password", Password);
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.HasRows)
                    {
                        reader.Read();
                        ID = reader.GetInt32(0).ToString();
                    }
                }
                connectionClose(con);
            }
            return new JavaScriptSerializer().Serialize(ID);
        }

        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public int Register(string FirstName, string LastName, string Gender, string Email, string Password, string Birthday)
        {
            int retRecord = 0;
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.AddNewUser", con))
                {
                    int GndrID = 0;
                    if (Gender == "Male")
                    {
                        GndrID = 1;
                    }
                    else if (Gender == "Female")
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
                    cmd.ExecuteNonQuery();
                }
                retRecord = 1;
                connectionClose(con);
            }
            return retRecord;
        }

        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public string GetProfileByID(string UserID)
        {
            var ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.GetFullUserInfo", con))
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
                }
                connectionClose(con);
            }
            return DataSetToJSONWithJSONNet(ds);
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public string GetEventList(string UserID, string Date)
        {
            var ds = new DataSet();
            DateTime date = Convert.ToDateTime(Date);
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.GetEventList", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserID", UserID);
                    cmd.Parameters.AddWithValue("@EventDate", date);
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    SqlDataAdapter adp = new SqlDataAdapter();
                    adp.SelectCommand = cmd;
                    adp.Fill(ds);
                }
                connectionClose(con);
            }
            return DataSetToJSONWithJSONNet(ds);
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public string GetEventSearchList(string UserID, string EventTitle)
        {
            int uID = Convert.ToInt32(UserID);
            var ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.GetEventSearchList", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserID", uID);
                    cmd.Parameters.AddWithValue("@EventTitle", EventTitle);
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    SqlDataAdapter adp = new SqlDataAdapter();
                    adp.SelectCommand = cmd;
                    adp.Fill(ds);
                }
                connectionClose(con);
            }
            return DataSetToJSONWithJSONNet(ds);
        }
        public string DataTableToJSONWithJSONNet(DataTable table)
        {
            string JSONString = string.Empty;
            JSONString = JsonConvert.SerializeObject(table, Formatting.Indented);
            return JSONString;
        }
        public string DataSetToJSONWithJSONNet(DataSet set)
        {
            string JSONString = string.Empty;
            JSONString = JsonConvert.SerializeObject(set, Formatting.Indented);
            return JSONString;
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public void UpdatePassword(string UserID, string Password)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.UpdatePassword", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserID", UserID);//("FirstName", SqlDbType.VarChar, 100).Value = Fname;
                    cmd.Parameters.AddWithValue("@Password", Password);//("Password", SqlDbType.VarChar, 200).Value = Password;
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    cmd.ExecuteNonQuery();
                }
                connectionClose(con);
            }
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public string EventCount(string UserID, string Date)
        {
            int count = 0;
            int UserIDtmp = Convert.ToInt32(UserID);
            DateTime Datetmp = Convert.ToDateTime(Date);
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.GetEventCount", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserID", UserIDtmp);
                    cmd.Parameters.AddWithValue("@Date", Datetmp);
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.HasRows)
                    {
                        reader.Read();
                        count = reader.GetInt32(0);
                    }
                    else
                    {
                        count = 0;
                    }
                }
                connectionClose(con);
            }
            return count.ToString();
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public string GetEvent(string UserID, string EventID)
        {
            var ds = new DataSet();
            int UserIDtmp = Convert.ToInt32(UserID);
            int EventIDtmp = Convert.ToInt32(EventID);
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.GetEvent", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserID", UserIDtmp);
                    cmd.Parameters.AddWithValue("@EventID", EventIDtmp);
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    SqlDataAdapter adp = new SqlDataAdapter();
                    adp.SelectCommand = cmd;
                    adp.Fill(ds);
                }
                connectionClose(con);
            }
            return DataSetToJSONWithJSONNet(ds);
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public void DeleteEvent(string UserID, string EventID)
        {
            int UserIDtmp = Convert.ToInt32(UserID);
            int EventIDtmp = Convert.ToInt32(EventID);
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.DeleteEvent", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserID_FK", UserIDtmp);
                    cmd.Parameters.AddWithValue("@EventID", EventIDtmp);
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    cmd.ExecuteNonQuery();
                }
                connectionClose(con);
            }
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public void UpdateEvent(string EventID,string UserID, string PriorityType, string EventTitle, string EventDesc, string EventDate, string EventStart, string EventEnd)
        {
            int eventIDtmp = Convert.ToInt32(EventID);
            int userIDtmp = Convert.ToInt32(UserID);
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.UpdateEvent", con))
                {
                    DateTime EDate = Convert.ToDateTime(EventDate);
                    DateTime EStart = Convert.ToDateTime(EventStart);
                    DateTime EEnd = Convert.ToDateTime(EventEnd);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@EventID", eventIDtmp);
                    cmd.Parameters.AddWithValue("@UserID_FK", userIDtmp);
                    cmd.Parameters.AddWithValue("@PriorityType", PriorityType);
                    cmd.Parameters.AddWithValue("@EventTitle", EventTitle);
                    cmd.Parameters.AddWithValue("@EventDescription", EventDesc);
                    cmd.Parameters.AddWithValue("@EventDate", EDate);
                    cmd.Parameters.AddWithValue("@EventStartTime", EStart);
                    cmd.Parameters.AddWithValue("@EventEndTime", EEnd);
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    cmd.ExecuteNonQuery();
                }
                connectionClose(con);
            }
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public string AddNewObjective(int UserID, string RepetitionType, string PriorityType, string ObjectiveTitle, string ObjectiveDesc, string ObjectiveDate, string ObjectiveCounter)
        {
            int retRecord = 0;
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.AddNewObjective", con))
                {
                    DateTime EDate = Convert.ToDateTime(ObjectiveDate);
                    int counter = Convert.ToInt32(ObjectiveCounter);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserID_FK", UserID);
                    cmd.Parameters.AddWithValue("@RepetitionType", RepetitionType);
                    cmd.Parameters.AddWithValue("@PriorityType", PriorityType);
                    cmd.Parameters.AddWithValue("@ObjectiveTitle", ObjectiveTitle);
                    cmd.Parameters.AddWithValue("@ObjectiveDescription", ObjectiveDesc);
                    cmd.Parameters.AddWithValue("@ObjectiveDate", EDate);
                    cmd.Parameters.AddWithValue("@ObjectiveCount", counter);
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    retRecord = 1;
                    cmd.ExecuteNonQuery();
                }
                connectionClose(con);
            }
            return new JavaScriptSerializer().Serialize(retRecord);
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public string GetObjective(string UserID, string EventID)
        {
            var ds = new DataSet();
            int UserIDtmp = Convert.ToInt32(UserID);
            int EventIDtmp = Convert.ToInt32(EventID);
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.GetObjective", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserID", UserIDtmp);
                    cmd.Parameters.AddWithValue("@ObjectiveID", EventIDtmp);
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    SqlDataAdapter adp = new SqlDataAdapter();
                    adp.SelectCommand = cmd;
                    adp.Fill(ds);
                }
                connectionClose(con);
            }
            return DataSetToJSONWithJSONNet(ds);
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public string GetObjectiveList(string UserID, string Date)
        {
            var ds = new DataSet();
            DateTime date = Convert.ToDateTime(Date);
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.GetObjectiveList", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserID", UserID);
                    cmd.Parameters.AddWithValue("@ObjectiveDate", date);
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    SqlDataAdapter adp = new SqlDataAdapter();
                    adp.SelectCommand = cmd;
                    adp.Fill(ds);
                }
                connectionClose(con);
            }
            return DataSetToJSONWithJSONNet(ds);
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public void DeleteObjective(string UserID, string ObjectiveID)
        {
            int UserIDtmp = Convert.ToInt32(UserID);
            int objectiveIDtmp = Convert.ToInt32(ObjectiveID);
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.DeleteObjective", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserID_FK", UserIDtmp);
                    cmd.Parameters.AddWithValue("@ObjectiveID", objectiveIDtmp);
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    cmd.ExecuteNonQuery();
                }
                connectionClose(con);
            }
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public string ObjectiveCount(string UserID, string Date)
        {
            int count = 0;
            int UserIDtmp = Convert.ToInt32(UserID);
            DateTime Datetmp = Convert.ToDateTime(Date);
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.GetObjectiveCount", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserID", UserIDtmp);
                    cmd.Parameters.AddWithValue("@Date", Datetmp);
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.HasRows)
                    {
                        reader.Read();
                        count = reader.GetInt32(0);
                    }
                    else
                    {
                        count = 0;
                    }
                }
                connectionClose(con);
            }
            return count.ToString();
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public string EventSearchCount(string UserID, string EventTitle)
        {
            int count = 0;
            int UserIDtmp = Convert.ToInt32(UserID);
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.EventSearchCount", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserID", UserIDtmp);
                    cmd.Parameters.AddWithValue("@EventTitle", EventTitle);
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.HasRows)
                    {
                        reader.Read();
                        count = reader.GetInt32(0);
                    }
                    else
                    {
                        count = 0;
                    }
                }
                connectionClose(con);
            }
            return count.ToString();
        }
        [WebMethod]
        [ScriptMethod(UseHttpGet = false)]
        public void UpdateObjectiveStatus(string UserID, string ObjectiveID, string CheckBoxStatus)
        {
            int objectiveIDtmp = Convert.ToInt32(ObjectiveID);
            int userIDtmp = Convert.ToInt32(UserID);
            bool tempStatus = Convert.ToBoolean(CheckBoxStatus);
            int stat = 0;
            if(tempStatus == true)
            {
                stat = 1;
            }
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["con"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("dbo.UpdateObjectiveStatus", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ObjectiveID", objectiveIDtmp);
                    cmd.Parameters.AddWithValue("@UserID_FK", userIDtmp);
                    cmd.Parameters.AddWithValue("@ObjectiveDoneFlag", stat);
                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    cmd.ExecuteNonQuery();
                }
                connectionClose(con);
            }
        }
    }
}
