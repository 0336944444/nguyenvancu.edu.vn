function ModalWindow(url, title, width, height, onBeforeOpen, onClosed)
{
    this._url = url;
    
    if (title == null)
    {
        this._title = 'Untitle';
    }
    else
    {
        this._title = title;
    }
    
    if (width == null)
    {    
        this._width = 500;
    }
    else
    {
        this._width = width;    
    }

    if (height == null)
    {    
        this._height = 500;
    }
    else
    {
        this._height = height;    
    }
        
    this._onBeforeOpen = onBeforeOpen;
    this._onClosed = onClosed;   
}

ModalWindow.prototype.set_url = function (value)
{
    this._url = value;
};

ModalWindow.prototype.get_url = function ()
{
    return this._url;
};

ModalWindow.prototype.set_title = function (value)
{
    this._title = value;
};

ModalWindow.prototype.get_title = function ()
{
    return this._title;
};

ModalWindow.prototype.set_width = function (value)
{
    this._width = value;
};

ModalWindow.prototype.get_width = function ()
{
    return this._width;
};

ModalWindow.prototype.set_height = function (value)
{
    this._height = value;
};

ModalWindow.prototype.get_height = function ()
{
    return this._height;
};

ModalWindow.prototype.onBeforeOpen = function (value)
{
    this._onBeforeOpen = value;
};

ModalWindow.prototype.onClosed = function (value)
{
    this._onClosed = value;
};

ModalWindow.prototype.open = function ()
{
    if (this._url == null)
    {
        alert('Modal window URL is not specified.');        
        return;
    }
    
    showPopWin(this._url, this._title, this._width, this._height, this._onBeforeOpen, this._onClosed);
};

ModalWindow.close = function (raiseOnClosed)
{
    hidePopWin(raiseOnClosed);
};