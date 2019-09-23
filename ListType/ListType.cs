using System;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.IO;

[Serializable]
[SqlUserDefinedType(Format.UserDefined, IsByteOrdered = true, MaxByteSize = -1)]
public class ListType : INullable, IBinarySerialize
{
    private bool _isNull;
    private int _length = 0;
    private string[] _list = new string[5];


    public bool IsNull
    {
        get
        {
            return _isNull;
        }
    }

    public static ListType Null
    {
        get
        {
            ListType listType = new ListType()
            {
                _isNull = true,
                _length = 0
            };
            return listType;
        }
    }


    [SqlMethod(OnNullCall = false)]
    public static ListType Parse(SqlString sqlString)
    {
        if (sqlString.IsNull)
            return Null;

        ListType list = new ListType();
        list._list = list.GetStringArray(sqlString.Value, ref list._length);
        return list;
    }


    public override string ToString()
    {
        return string.Join(",", _list, 0, _length);
    }

    public void AddItem(string item)
    {
        _list.SetValue(item, _length);
        _length += 1;
    }

    public string GetItem(int index)
    {
        if (index >= 0 && index < _length)
        {
            return _list[index];
        }
        return string.Format("Index out of bound");
    }

    public void Read(BinaryReader r)
    {
        var message = r.ReadString();
        _list = message.Split(',');
        _length = r.ReadInt32();
    }

    public void Write(BinaryWriter w)
    {
        var message = ToString();
        w.Write(message);
        w.Write(_length);
    }

    public string[] GetStringArray(string text, ref int length)
    {
        string[] delimiters = new string[4] { " , ", " ,", ", ", "," };
        string[] finalList = new string[5];

        string[] words = (text.Split(delimiters, StringSplitOptions.RemoveEmptyEntries));
        length = words.Length > 5 ? 5 : words.Length;
        for (int i = 0; i < 5 && i < length; i++)
        {
            finalList.SetValue(words[i], i);
        }

        return finalList;
    }
}
