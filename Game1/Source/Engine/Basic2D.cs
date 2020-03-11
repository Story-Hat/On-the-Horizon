using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace On_the_Horizon
{
    public class Basic2D
    {
        public float rot;
        public Vector2 pos, dims;
        public Texture2D texture;
        public Basic2D(string PATH, Vector2 POS, Vector2 DIMS)
        {
            pos = POS;
            dims = DIMS;

            texture = Globals.content.Load<Texture2D>(PATH);

        }

        public virtual void Update()
        {

        }

        public virtual void Draw(Vector2 offset)
        {
            if(texture != null)
            {
                Globals.spriteBatch.Draw(texture, new Rectangle((int)(pos.X + offset.X), (int)(pos.Y + offset.Y), (int)dims.X, (int)dims.Y), null, Color.White, rot, new Vector2(texture.Bounds.Width / 2, texture.Bounds.Height / 2), new SpriteEffects(), 0);
            }
        }

        public virtual void Draw(Vector2 offset, Vector2 origin)
        {
            if(texture != null)
            {
                Globals.spriteBatch.Draw(texture, new Rectangle((int)(pos.X + offset.X), (int)(pos.Y + offset.Y), (int)dims.X, (int)dims.Y), null, Color.White, rot, new Vector2(origin.X, origin.Y), new SpriteEffects(), 0);
            }
        }
    }
}
